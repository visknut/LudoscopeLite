//////////////////////////////////////////////////////////////////////////////
//
// Transform Grammars
// @brief        Functions that move the relevant content from the AST to
//							 a new ADT declared in DataStructures.rsc.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         23-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::transformations::Grammar

import parsing::languages::grammar::AST;
import parsing::Parser;
import parsing::DataStructures;
import parsing::transformations::Utility;

alias AbstractGrammar = parsing::languages::grammar::AST::Grammar;
alias AbstractRule = parsing::languages::grammar::AST::Rule;

public TransformationArtifact transformGrammars(TransformationArtifact artifact, 
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
		
		transformedRules += (abstractRule.name : newRule);
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
	
	int i = 0;
	list[Tile] row = [];
	for (Symbol symbol <- symbols)
	{
		row += [symbol.name];
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
			list[MatchingSymbol] symbols, tileMap(int width, int height), int moduleIndex)
{
	TileMap newTileMap = [];
	str alphabetName = artifact.project.modules[moduleIndex].alphabetName;
	
	int i = 0;
	list[Tile] row = [];
	for (MatchingSymbol symbol <- symbols)
	{
		row += symbol.name;
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