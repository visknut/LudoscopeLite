//////////////////////////////////////////////////////////////////////////////
//
// Instructions that apply rules to the map.
// @brief        This file contains the functions for  the instructions 
//							 that apply rules.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         20-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module execution::instructions::Instructions

import execution::instructions::Matching;
import parsing::DataStructures;
import List;

// TODO: replace itterateRule with something that stops when tileMap doesn't change.
public TileMap executeInstruction(TileMap tileMap, RuleMap rules, executeRule(str ruleName, int itterations))
{
	for (int i <- [0 .. itterations])
	{
		tileMap = executeInstruction(tileMap, rules, itterateRule(ruleName));
	}
	return tileMap;
}

public TileMap executeInstruction(TileMap tileMap, RuleMap rules, itterateRule(str ruleName))
{
	Rule rule = rules[ruleName];
	list[Coordinates] matches = findPatternInGrid(tileMap, rule.leftHand);
	if (size(matches) > 0)
	{
		Coordinates match = getOneFrom(matches);
		TileMap replacement = getOneFrom(rule.rightHands);
		int patternWidth = size(rule.leftHand[0]);
		int patternHeight = size(rule.leftHand);
		
		for (int i <- [0 .. patternWidth])
		{
			for (int j <- [0 .. patternHeight])
			{
				tileMap[j + match.y][i + match.x] = replacement[j][i];
			}
		}
			
	}
	return tileMap;
}

