//////////////////////////////////////////////////////////////////////////////
//
// Property Validation
// @brief        This file contains the function that validate a lpl property.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         22-05-2018
//
//////////////////////////////////////////////////////////////////////////////

module execution::lpl::PropertyValidation

import List;
import execution::DataStructures;
import parsing::DataStructures;

public bool checkProperty
(
	occurrence(int count, SymbolIndex tile), 
	PropertyHistory history,
	ExtendedTileMaps maps
)
{
	//TileMap containedMap;
	//int containedIndex;
	//switch (contained)
	//{
	//	case symbolTile(int symbolIndex) : 
	//	{
	//		containedMap = maps.tileIndex;
	//		containedIndex = symbolIndex;
	//	}
	//	case ruleTile(int ruleIndex) : 
	//	{
	//		containedMap = maps.ruleIndex;
	//		containedIndex = ruleIndex;
	//	}
	//	case moduleTile(int moduleIndex) :
	//	{
	//		containedMap = maps.moduleIndex;
	//		containedIndex = moduleIndex;
	//	}
	//}
	//
	//for (int y <- [0 .. size(containedMap)])
	//{
	//	for (int x <- [0 .. size(containedMap[0])])
	//	{
	//		if (containedMap[y][x] == containedIndex)
	//		{
	//			if (!contained(x, y, container, history))
	//			{
	//				return false;
	//			}
	//		}
	//	}
	//}
	return true;
}

public bool checkProperty
(
	occurrence(int count, SymbolIndex tile, RuleIndex rule), 
	PropertyHistory history,
	ExtendedTileMaps maps
)
{
	return true;
}

public bool checkProperty
(
	adjecent(SymbolIndex tile, SymbolIndex adjecentTile), 
	PropertyHistory history,
	ExtendedTileMaps maps
)
{
	return true;
}


