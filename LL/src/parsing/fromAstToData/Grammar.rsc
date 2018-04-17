//////////////////////////////////////////////////////////////////////////////
//
// Transfer grammar files
// @brief        This file contains functions that transfers the data from the
//							 The AST to the data structures.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         17-04-2018
//
//////////////////////////////////////////////////////////////////////////////


module parsing::fromAstToData::Grammar

import IO;
import Exception;
import parsing::languages::grammar::AST;
import parsing::DataStructures;
import util::string;


public ParsingArtifact parseGrammar(ParsingArtifact artifact, str fileName)
{
	list[Instruction] recipe = [];
	loc grammarFile = fileLocation(artifact.environment.projectFile, fileName, ".grm");
		
	if (exists(grammarFile))
	{
		parsing::languages::grammar::AST::Grammar abstractGrammar
			= parseGrammarToAST(grammarFile);
			
		artifact.environment.newModule.startingState = parseExpression(artifact,
			abstractGrammar.startInput.expression.symbols,
			abstractGrammar.startInput.expression.mapType);
		
		artifact = parseRules(artifact, abstractGrammar.rules);
	}
	else
	{
		artifact.environment.errors += [errors::Parsing::fileNotFound(grammarFile)];
	}
	
	return artifact;
}

private ParsingArtifact parseRules(ParsingArtifact artifact,
			list[parsing::languages::grammar::AST::Rule] rules)
{
	for (parsing::languages::grammar::AST::Rule abstractRule <- rules)
	{
		Topology topology = parseSettings(abstractRule.settings);
		TileMap leftHand = parseExpression(artifact,
			abstractRule.leftHand.symbols,
			abstractRule.leftHand.mapType);
		list[TileMap] rightHands = parseRightHands(artifact,
			abstractRule.rightHands);
		Rule newRule = parsing::DataStructures::rule(topology, leftHand, rightHands);
		
		artifact.environment.newModule.rules += (abstractRule.name : newRule);
	}
	return artifact;
}

private list[TileMap] parseRightHands(ParsingArtifact artifact,
			list[RightHandExpression] abstractRightHands)
{
	list[TileMap] rightHands = [];
	for (RightHandExpression rightHand <- abstractRightHands)
	{
		rightHands += [parseExpression(artifact, rightHand.expression.symbols, 
			rightHand.expression.mapType)];
	}
	return rightHands;
}

private Topology parseSettings(list[RuleSetting] settings)
{
		Topology topology = topology(false, false, false);
		for (RuleSetting setting <- settings)
		{
			if (ruleTopology(int i) := setting)
			{
				topology = parseTopology(setting.topology);
			}
		}
		return topology;
}

public Topology parseTopology(int i)
{
	bool mirrorHorizontal = false;
	bool mirrorVertical = false;
	bool rotate = false;
	
	if ((i / 4) >= 1)
	{
		rotate = true;
		i = i - 4;
	}
	
	if ((i / 2) >= 1)
	{
		mirrorVertical = true;
		i = i - 2;
	}
	
	if (i == 1)
	{
		mirrorHorizontal = true;
	}

	return topology(mirrorHorizontal, mirrorVertical, rotate);
}

private TileMap parseExpression(ParsingArtifact artifact,
			list[Symbol] symbols, 
			tileMap(int width, int height))
{
	TileMap newTileMap = [];
	int i = 0;
	list[Tile] row = [];
	Alphabet alphabet = 
		artifact.project.alphabets[artifact.environment.newModule.alphabetName];
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

private TileMap parseExpression(ParsingArtifact artifact,
			list[Symbol] symbols,
			string())
{
	println("Error: unsuported map type.");
	return [[]];
}

private TileMap parseExpression(ParsingArtifact artifact,
			list[Symbol] symbols, 
			graph())
{
	println("Error: unsuported map type.");
	return [[]];
}

private TileMap parseExpression(ParsingArtifact artifact,
			list[Symbol] symbols, 
			shape())
{
	println("Error: unsuported map type.");
	return [[]];
}

private TileMap parseExpression(ParsingArtifact artifact,
			list[LeftHandSymbol] symbols, 
			tileMap(int width, int height))
{
	TileMap newTileMap = [];
	int i = 0;
	list[Tile] row = [];
	Alphabet alphabet = 
		artifact.project.alphabets[artifact.environment.newModule.alphabetName];
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

private TileMap parseExpression(ParsingArtifact artifact,
			list[LeftHandSymbol] symbols,
			string())
{
	println("Error: unsuported map type.");
	return [[]];
}

private TileMap parseExpression(ParsingArtifact artifact,
			list[LeftHandSymbol] symbols, 
			graph())
{
	println("Error: unsuported map type.");
	return [[]];
}

private TileMap parseExpression(ParsingArtifact artifact,
			list[LeftHandSymbol] symbols, 
			shape())
{
	println("Error: unsuported map type.");
	return [[]];
}