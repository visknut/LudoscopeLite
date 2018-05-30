//////////////////////////////////////////////////////////////////////////////
//
// Transform to MAD data structures.
// @brief        This file contains functions that transform the LL data
//						   structures to and from the data structures used in the MAD.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         18-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module analysis::madWrapper::DataTransformation

import List;
import util::mad::Metric;
import util::mad::AST;

import analysis::madWrapper::MADFramework;
import analysis::madWrapper::SymbolHierarchy;

import parsing::DataStructures;

alias MadRuleMap = tuple[int width, MadRule rule];
alias MadRuleScoreMap = tuple[int width, MadRuleScore ruleScore];
alias CleanRule = tuple[TileMap leftHand, TileMap rightHand];

public list[MadRuleMap] ludoscopeRuleToMadRuleMaps(Rule ludoscopeRule)
{
	list[CleanRule] cleanRules = ludoscopeRuleToCleanRules(ludoscopeRule);
	return [cleanRuleToMadRuleMap(cleanRule) | CleanRule cleanRule <- cleanRules];
}

public list[RightHandScore] madRuleScoreMapToRightHandScores
(
	list[MadRuleScoreMap] madRuleScores
)
{
	return [<sumRuleScore(rule.ruleScore), madRuleScoreToTileMap(rule)>
		| MadRuleScoreMap rule <- madRuleScores];
}

public Detail symbolHierarchyToDetail
(
	SymbolHierarchy symbolHierarchy
)
{
	Detail detail = {};
	for (SymbolGroup symbolGroup <- symbolHierarchy)
	{
		SymbolGroup lowerSymbols = getLowerSymbols(symbolHierarchy, symbolGroup);
		detail += SymbolGroupToDetail(symbolGroup, lowerSymbols);
	}
	return detail;
}

private list[CleanRule] ludoscopeRuleToCleanRules
(
	Rule ludoscopeRule
)
{
	return [<ludoscopeRule.leftHand, rightHand> 
		|	TileMap rightHand <- ludoscopeRule.rightHands];
}

private HeatMap madRuleScoreToTileMap
(
	MadRuleScoreMap madRuleScore
)
{
	HeatMap heatMap = [];
	list[int] row = [];
	
	for (int score <- madRuleScore.ruleScore.score)
	{
		row += [score];
		if (size(row) == madRuleScore.width)
		{
			heatMap += [row];
			row = [];
		}
	}
	
	return heatMap;
}

private MadRuleMap cleanRuleToMadRuleMap
(
	CleanRule rule
)
{
	MadRule madRule = [];
	for (int y <- [0 .. size(rule.leftHand)])
	{
		for (int x <- [0 .. size(head(rule.leftHand))])
		{
			madRule += [<"<rule.leftHand[y][x]>", "<rule.rightHand[y][x]>">];
		}
	}
	return <size(head(rule.leftHand)), madRule>;
}

private Detail SymbolGroupToDetail
(
	set[str] symbols, 
	set[str] lowerSymbols
)
{
	return {<"<symbol>", "<lowerSymbol>"> | 
		str symbol <- symbols, 
		str lowerSymbol <- lowerSymbols};
}

private set[str] getLowerSymbols
(
	SymbolHierarchy symbolHierarchy, 
	SymbolGroup symbols
)
{
	set[str] lowerSymbols = {};
	SymbolGroup currentSymbols = head(symbolHierarchy);
	symbolHierarchy = tail(symbolHierarchy);
	while (currentSymbols != symbols)
	{
		lowerSymbols += currentSymbols;
		currentSymbols = head(symbolHierarchy);
		symbolHierarchy = tail(symbolHierarchy);
	}
	
	return lowerSymbols;
}