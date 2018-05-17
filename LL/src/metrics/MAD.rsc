//////////////////////////////////////////////////////////////////////////////
//
// Implementation of MAD (Metric of Added Detail)
// @brief        This file contains the data structures and the functions
//							 needed to evaluate the amount of detail that is added by each
//							 rule in a project.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         05-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module metrics::MAD

import IO;
import List;
import util::Integer;

import parsing::DataStructures;
import execution::DataStructures;
import execution::ModuleHierarchy;
import metrics::SymbolHierarchy;

alias ProjectScore = map[str, ModuleScore];
alias ModuleScore = map[str, list[RightHandScore]];
alias RightHandScore = tuple[int, TileMap];

public ProjectScore calculateMAD(LudoscopeProject project)
{
	ModuleHierarchy moduleHierarchy = (extractModuleHierarchy(project)).hierarchy;
	SymbolHierarchy symbolHierarchy = extractSymbolHierarchy(moduleHierarchy);
	ProjectScore projectScore = ();
	
	for (LudoscopeModule ludoscopeModule <- project.modules)
	{
		projectScore += 
			(ludoscopeModule.name : calculateModuleScore(ludoscopeModule, symbolHierarchy));
	}
	
	return projectScore;
}

private ModuleScore calculateModuleScore
(
	LudoscopeModule ludoscopeModule, 
	SymbolHierarchy symbolHierarchy
)
{
	return (rule : calculateRuleScore(symbolHierarchy, ludoscopeModule.rules[rule]) 
		| str rule <- ludoscopeModule.rules);
}

private list[RightHandScore] calculateRuleScore
(
	SymbolHierarchy symbolHierarchy, 
	Rule rule
)
{
	list[RightHandScore] rightHandScores = [];
	for (TileMap rightHand <- rule.rightHands)
	{
		TileMap madMap = calculateMADMap(symbolHierarchy, rule.leftHand, rightHand);
		int madScore = sum([sum(row) | list[int] row <- madMap]);
		rightHandScores += [<madScore, madMap>];
	}
	return rightHandScores;
}

private TileMap calculateMADMap
(
	SymbolHierarchy symbolHierarchy, 
	TileMap leftHand, 
	TileMap rightHand
)
{
	TileMap madMap = [];
	for (int x <- [0 .. size(leftHand)])
	{
		list[int] newRow = [];
		for (int y <- [0 .. size(head(leftHand))])
		{
			newRow += 
				[compareSymbols(symbolHierarchy, leftHand[y][x], rightHand[y][x])];
		}
		madMap += [newRow];
	}
	return madMap;
}

private int compareSymbols
(
	SymbolHierarchy symbolHierarchy, 
	int leftSymbol, 
	int rightSymbol
)
{
	int leftRank = 0;
	int rightRank = 0;
	for (SymbolGroup group <- symbolHierarchy)
	{
		if (leftSymbol in group)
		{
			leftRank = indexOf(symbolHierarchy, group);
		}
		if (rightSymbol in group)
		{
		 	rightRank = indexOf(symbolHierarchy, group);
		}
	}
	
	return sign(rightRank - leftRank);
}