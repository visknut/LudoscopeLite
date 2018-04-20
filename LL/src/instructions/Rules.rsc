//////////////////////////////////////////////////////////////////////////////
//
// Instructions that apply rules to the map.
// @brief        This file contains the functions for  the instructions 
//							 that apply rules.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         20-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module instructions::Rules

import instructions::util::Matching;
import parsing::DataStructures;
import List;

// TODO: replace itterateRule with something that stops when tileMap doesn't change.
public TileMap executeRule(Rule rule, int itterations, TileMap tileMap)
{
	for (int i <- [0 .. itterations])
	{
		tileMap = itterateRule(rule, tileMap);
	}
	return tileMap;
}

public TileMap itterateRule(Rule rule, TileMap tileMap)
{
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

