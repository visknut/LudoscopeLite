module parsing::transformations::TransformSyntaxTree

import IO;
import List;
import parsing::Parser;
import parsing::DataStructures;

import parsing::transformations::TransformInstructions;

import parsing::languages::grammar::AST;
import parsing::languages::alphabet::AST;
import parsing::languages::recipe::AST;

import util::string;

alias AbstractAlphabet = parsing::languages::alphabet::AST::Alphabet;
alias AbstractInstruction = parsing::languages::recipe::AST::Instruction;
alias AbstractGrammar = parsing::languages::grammar::AST::Grammar;
alias AbstractRule = parsing::languages::grammar::AST::Rule;

public TransformationArtifact transformSyntaxTree(SyntaxTree syntaxTree)
{
	LudoscopeProject project = ludoscopeProject([], ());
	TransformationArtifact artifact = transformationArtifact(project, []);
	
	artifact = transformProject(artifact, syntaxTree);
	artifact = transformAplhabets(artifact, syntaxTree);
	artifact = transformGrammars(artifact, syntaxTree);
	artifact = transformRecipes(artifact, syntaxTree);
	
	return artifact;
}

//////////////////////////////////////////////////////////////////////////////
// Transform Project
//////////////////////////////////////////////////////////////////////////////

// TODO: implement options and registers.
private TransformationArtifact transformProject(TransformationArtifact artifact, 
	SyntaxTree syntaxTree)
{
	visit (syntaxTree.project[0])
	{
		case lspmodule(str name, str alphabet, str position, str moduleType, str fileName,
			str match, list[str] inputs, str maxIterations,	str moduleFilter,	str grammar,
			str executionType, str recipe, str showMembers, str alwaysStartWithToken) :
		{
			artifact.project.modules +=
				[ludoscopeModule(cleanGrammarName(name), 
												inputs, 
												cleanAlphabetName(alphabet), 
												[[]], 
												(), 
												[])];
		}
	}
	return artifact;
}

//////////////////////////////////////////////////////////////////////////////
// Transform Alphabet
//////////////////////////////////////////////////////////////////////////////

private TransformationArtifact transformAplhabets(TransformationArtifact artifact, 
	SyntaxTree syntaxTree)
{
	for (str fileName <- syntaxTree.alphabets)
	{
		Alphabet transformendAlphabet = ();
		int i = 0;
		AbstractAlphabet abstractAlphabet = syntaxTree.alphabets[fileName];
		for (Symbol symbol <- abstractAlphabet.symbols)
		{
			transformendAlphabet += (symbol.name : i);
			i += 1;
		}
		artifact.project.alphabets += (fileName : transformendAlphabet);
	}
	return artifact;
}

//////////////////////////////////////////////////////////////////////////////
// Transform Recipe
//////////////////////////////////////////////////////////////////////////////

private TransformationArtifact transformRecipes(TransformationArtifact artifact, 
	SyntaxTree syntaxTree)
{
	for (str recipeName <- syntaxTree.recipes)
	{
		int moduleIndex = findModuleIndex(recipeName, artifact);				
		for (AbstractInstruction instruction 
			<- syntaxTree.recipes[recipeName].instructions)
			{
				if (!instruction.commented)
				{
					artifact.project.modules[moduleIndex].recipe += 
						[parseInstruction(instruction)];
				}
			}
	}
	return artifact;
}

//////////////////////////////////////////////////////////////////////////////
// Transform Grammar
//////////////////////////////////////////////////////////////////////////////

private TransformationArtifact transformGrammars(TransformationArtifact artifact, 
	SyntaxTree syntaxTree)
{
	for (str grammarName <- syntaxTree.grammars)
	{
		int moduleIndex = findModuleIndex(grammarName, artifact);
		AbstractGrammar abstractGrammar = syntaxTree.grammars[grammarName];
		
		artifact.project.modules[moduleIndex].startingState = parseExpression(artifact,
			abstractGrammar.startInput.expression.symbols,
			abstractGrammar.startInput.expression.mapType,
			moduleIndex);
		
		artifact.project.modules[moduleIndex].rules = 
			parseRules(artifact, syntaxTree.grammars[grammarName].rules, moduleIndex);
	}
	
	return artifact;
}

private RuleMap parseRules(TransformationArtifact artifact, 
	list[AbstractRule] rules, int moduleIndex)
{
	RuleMap transformedRules = ();
	for (AbstractRule abstractRule <- rules)
	{
		Reflections reflections = parseSettings(abstractRule.settings);
		
		TileMap leftHand = parseExpression(artifact,
			abstractRule.leftHand.symbols,
			abstractRule.leftHand.mapType,
			moduleIndex);
			
		list[TileMap] rightHands = parseRightHands(artifact, 
			abstractRule.rightHands, moduleIndex);
			
		Rule newRule = parsing::DataStructures::rule(reflections, leftHand, rightHands);
		
		transformedRules += (abstractRule.name : newRule);
	}
	return transformedRules;
}

private list[TileMap] parseRightHands(TransformationArtifact artifact,
			list[RightHandExpression] abstractRightHands, int moduleIndex)
{
	list[TileMap] rightHands = [];
	for (RightHandExpression rightHand <- abstractRightHands)
	{
		rightHands += [parseExpression(artifact, rightHand.expression.symbols, 
			rightHand.expression.mapType, moduleIndex)];
	}
	return rightHands;
}

private Reflections parseSettings(list[RuleSetting] settings)
{
	list[bool] bitList = [false, false, false];
	for (RuleSetting setting <- settings)
	{
		switch (setting)
		{
			case ruleReflections(int reflections) :
			{
					bitList = parseBitFlag(reflections, 3);
			}
		}
	}
	return reflections(bitList[0], bitList[1], bitList[2]);
}

private TileMap parseExpression(TransformationArtifact artifact,
			list[Symbol] symbols, tileMap(int width, int height), int moduleIndex)
{
	TileMap newTileMap = [];
	str alphabetName = artifact.project.modules[moduleIndex].alphabetName;
	Alphabet alphabet = artifact.project.alphabets[alphabetName];
	
	int i = 0;
	list[Tile] row = [];
	for (Symbol symbol <- symbols)
	{
		row += [alphabet[symbol.name]];
		i += 1;
		if (i == width)
		{
			newTileMap += [row];
			row = [];
			i = 0;
		}
	}
	
	return newTileMap;
}

private TileMap parseExpression(TransformationArtifact artifact,
			list[LeftHandSymbol] symbols, tileMap(int width, int height), int moduleIndex)
{
	TileMap newTileMap = [];
	str alphabetName = artifact.project.modules[moduleIndex].alphabetName;
	Alphabet alphabet = artifact.project.alphabets[alphabetName];
	
	int i = 0;
	list[Tile] row = [];
	for (LeftHandSymbol symbol <- symbols)
	{
		row += [alphabet[symbol.name]];
		i += 1;
		if (i == width)
		{
			newTileMap += [row];
			row = [];
			i = 0;
		}
	}
	
	return newTileMap;
}

//////////////////////////////////////////////////////////////////////////////
// Utility functions
//////////////////////////////////////////////////////////////////////////////

private int findModuleIndex(str moduleName, TransformationArtifact artifact)
{
	for (int i <- [0 .. size(artifact.project.modules)])
	{
		if (artifact.project.modules[i].name == moduleName)
		{
			return i;
		}
	}
	return -1;
}

private list[bool] parseBitFlag(int bitFlag, int minimumSize)
{
	list[bool] bitList = [];
	
	while (bitFlag != 0)
	{
		if (bitFlag % 2 == 1)
		{
			bitList += [true];
		}
		else
		{
			bitList += [false];
		}
		bitFlag = bitFlag / 2;
	}
	
	for (int i <- [size(bitList) .. minimumSize])
	{
		bitList += [false];
	}
	return bitList;
}