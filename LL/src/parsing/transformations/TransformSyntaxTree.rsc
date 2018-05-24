//////////////////////////////////////////////////////////////////////////////
//
// Transform AST
// @brief        Functions that move the relevant content from the AST to
//							 a new ADT declared in DataStructures.rsc.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         23-04-2018
//
//////////////////////////////////////////////////////////////////////////////

// TODO: put transformations in seprate files.
module parsing::transformations::TransformSyntaxTree

import IO;
import List;
import parsing::Parser;
import parsing::DataStructures;

import parsing::transformations::TransformInstructions;

import parsing::languages::grammar::AST;
import parsing::languages::alphabet::AST;
import parsing::languages::recipe::AST;
import parsing::languages::lpl::AST;

import errors::Parsing;

import util::string;

alias AbstractAlphabet = parsing::languages::alphabet::AST::Alphabet;
alias AbstractInstruction = parsing::languages::recipe::AST::Instruction;
alias AbstractGrammar = parsing::languages::grammar::AST::Grammar;
alias AbstractRule = parsing::languages::grammar::AST::Rule;

data Name
 = moduleName(int nameIndex)
 | ruleName(int nameIndex)
 | symbolName(int nameIndex)
 | undefinedName(str name);

public TransformationArtifact transformSyntaxTree(SyntaxTree syntaxTree)
{
	LudoscopeProject project = ludoscopeProject([], (), [], [], []);
	TransformationArtifact artifact = transformationArtifact(project, []);
	
	artifact = transformProject(artifact, syntaxTree);
	artifact = transformAplhabets(artifact, syntaxTree);
	artifact = transformGrammars(artifact, syntaxTree);
	artifact = transformRecipes(artifact, syntaxTree);
	artifact = transformProperties(artifact, syntaxTree);
	
	artifact = addEmptyRecipes(artifact);
	
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
			list[str] cleanInputs = [removeQuotes(input) | str input <- inputs];
			int moduleNameIndex = size(artifact.project.moduleNames);
			artifact.project.moduleNames += [cleanGrammarName(name)];
			artifact.project.modules +=
				[unfinishedLudoscopeModule(moduleNameIndex, 
												cleanInputs,
												cleanAlphabetName(alphabet), 
												[[]], 
												(), 
												[])];
		}
	}
	
	artifact = replaceInputStrings(artifact);
	return artifact;
}

private TransformationArtifact replaceInputStrings
(
	TransformationArtifact artifact
)
{
	return visit (artifact)
	{
		case unfinishedLudoscopeModule(int nameIndex,
		list[str] inputStrings,
		str alphabetName,
		TileMap startingState, 
		RuleMap rules, 
		Recipe recipe) => 
		ludoscopeModule(nameIndex,
		[indexOf(artifact.project.moduleNames, inputName) | str inputName <- inputStrings],
		alphabetName,
		startingState, 
		rules, 
		recipe)
	};
}

//////////////////////////////////////////////////////////////////////////////
// Transform Alphabet
//////////////////////////////////////////////////////////////////////////////

private TransformationArtifact transformAplhabets(TransformationArtifact artifact, 
	SyntaxTree syntaxTree)
{
	for (str fileName <- syntaxTree.alphabets)
	{
		SymbolNameList transformendAlphabet = [];
		AbstractAlphabet abstractAlphabet = syntaxTree.alphabets[fileName];
		for (Symbol symbol <- abstractAlphabet.symbols)
		{
			transformendAlphabet += [symbol.name];
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
					[parseInstruction(artifact, instruction)];
			}
		}
	}
	return artifact;
}

private TransformationArtifact addEmptyRecipes(TransformationArtifact artifact)
{
	visit(artifact)
	{
		case ludoscopeModule(nameIndex, inputs,	alphabetName,	startingState, rules, []) : 
		{
			str name = artifact.project.moduleNames[nameIndex];
			int moduleIndex = findModuleIndex(name, artifact);
			artifact.project.modules[moduleIndex].recipe += [executeGrammar()];
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
		
		artifact = 
			parseRules(artifact, syntaxTree.grammars[grammarName].rules, moduleIndex);
	}
	
	return artifact;
}

private TransformationArtifact parseRules(TransformationArtifact artifact, 
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
		
		int ruleNameIndex = size(artifact.project.ruleNames);
		artifact.project.ruleNames += [abstractRule.name];
		transformedRules += (ruleNameIndex : newRule);
	}
	artifact.project.modules[moduleIndex].rules = transformedRules;
	return artifact;
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
	SymbolNameList alphabet = artifact.project.alphabets[alphabetName];
	
	int i = 0;
	list[Tile] row = [];
	for (Symbol symbol <- symbols)
	{
		row += [indexOf(alphabet, symbol.name)];
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

// TODO: remove duplicate function.
private TileMap parseExpression(TransformationArtifact artifact,
			list[LeftHandSymbol] symbols, tileMap(int width, int height), int moduleIndex)
{
	TileMap newTileMap = [];
	str alphabetName = artifact.project.modules[moduleIndex].alphabetName;
	SymbolNameList alphabet = artifact.project.alphabets[alphabetName];
	
	int i = 0;
	list[Tile] row = [];
	for (LeftHandSymbol symbol <- symbols)
	{
		row += [indexOf(alphabet, symbol.name)];
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
// Transform Properties
//////////////////////////////////////////////////////////////////////////////

private TransformationArtifact transformProperties
(
	TransformationArtifact artifact, 
	SyntaxTree syntaxTree
)
{
	visit(syntaxTree)
	{
		case Property property:
		{
			artifact = 
				transformProperty(artifact, property, property@location);
		}
	}
	return artifact;
}

public TransformationArtifact transformProperty
(
	TransformationArtifact artifact,
	adjecent(bool negation, str tile, str adjecentTile),
	loc propertyLocation
)
{
	Property property =
		parsing::DataStructures::adjecent(negation, symbolIndex(-1), symbolIndex(-1));
		
	Name tileType = findName(artifact, tile);
	switch (tileType)
	{
		case symbolName(int nameIndex) :
		{
			property.tile.index = nameIndex;
		}
 		case ruleName(int nameIndex) :
 		{
 			artifact.errors += [structureType("rule", propertyLocation)];
 			return artifact;
 		}
 		case moduleName(int nameIndex) :
 		{
 			artifact.errors = [structureType("module", propertyLocation)];
 			return artifact;
 		}
 		case undefinedName(str name) :
 		{
 			artifact.errors += [propertyName(name, propertyLocation)];
 			return artifact;
 		}
	}
	
	Name adjecentType = findName(artifact, adjecentTile);
	switch (adjecentType)
	{
		case symbolName(int nameIndex) :
		{
			property.adjecentTile.index = nameIndex;
		}
 		case ruleName(int nameIndex) :
 		{
 			artifact.errors += [structureType("rule", propertyLocation)];
 			return artifact;
 		}
 		case moduleName(int nameIndex) :
 		{
 			artifact.errors = [structureType("module", propertyLocation)];
 			return artifact;
 		}
 		case undefinedName(str name) :
 		{
 			artifact.errors += [propertyName(name, propertyLocation)];
 			return artifact;
 		}
	}
	
	artifact.project.properties += [property];
	return artifact;
}

public TransformationArtifact transformProperty
(
	TransformationArtifact artifact,
	occurrence(int count, str containted, str container),
	loc propertyLocation
)
{
	Property property;
	if (container == "")
	{
		property = 
			parsing::DataStructures::occurrence(count, symbolIndex(-1));
	}
	else
	{
		property = 
			parsing::DataStructures::occurrence(count, symbolIndex(-1), ruleIndex(-1));
	}
	
	Name containedType = findName(artifact, containted);
	switch (containedType)
	{
		case symbolName(int nameIndex) :
		{
			property.tile.index = nameIndex;
		}
 		case ruleName(int nameIndex) :
 		{
 			artifact.errors += [structureType("rule", propertyLocation)];
 			return artifact;
 		}
 		case moduleName(int nameIndex) :
 		{
 			artifact.errors = [structureType("module", propertyLocation)];
 			return artifact;
 		}
 		case undefinedName(str name) :
 		{
 			artifact.errors += [propertyName(name, propertyLocation)];
 			return artifact;
 		}
	}
	
	if (container != "")
	{
		Name containerType = findName(artifact, cleanContainerName(container));
		switch (containerType)
		{
			case symbolName(int nameIndex) :
			{
				artifact.errors += [structureType("symbol", propertyLocation)];
				return artifact;
			}
	 		case ruleName(int nameIndex) :
	 		{
				property.rule.index = nameIndex;
	 		}
	 		case moduleName(int nameIndex) :
	 		{
	 			artifact.errors = [structureType("module", propertyLocation)];
	 			return artifact;
	 		}
	 		case undefinedName(str name) :
	 		{
	 			artifact.errors += [propertyName(name, propertyLocation)];
	 			return artifact;
	 		}
		}
	}
	
	artifact.project.properties += [property];
	return artifact;
}

public Name findName
(
	TransformationArtifact artifact,
	str name
)
{
	for (str alphabetName <- artifact.project.alphabets)
	{
		SymbolNameList symbolNames = artifact.project.alphabets[alphabetName];
		if (name in symbolNames)
		{
			return symbolName(indexOf(symbolNames, name));
		}
	}
	if (name in artifact.project.moduleNames)
	{
		return moduleName(indexOf(artifact.project.moduleNames, name));
	}
	else if (name in artifact.project.ruleNames)
	{
		return ruleName(indexOf(artifact.project.ruleNames, name));
	}
	return undefinedName(name);
}

//////////////////////////////////////////////////////////////////////////////
// Utility functions
//////////////////////////////////////////////////////////////////////////////

private int findModuleIndex(str moduleName, TransformationArtifact artifact)
{
	int moduleNameIndex = indexOf(artifact.project.moduleNames, moduleName);
	for (int i <- [0 .. size(artifact.project.modules)])
	{
		if (artifact.project.modules[i].nameIndex == moduleNameIndex)
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