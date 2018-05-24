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
	Property extendedOccurrence =	occurrence(count, tile, ruleIndex(-1));
	return checkProperty(extendedOccurrence, history, maps);
}

public bool checkProperty
(
	occurrence(int count, SymbolIndex tile, RuleIndex rule), 
	PropertyHistory history,
	ExtendedTileMaps maps
)
{
	TileMap tileMap = maps.tileIndex;
	int counted = 0;
	for (int y <- [0 .. size(tileMap)])
	{
		for (int x <- [0 .. size(tileMap[0])])
		{
			if (tileMap[y][x] == tile.index
			&& 	placedOn(history, x, y, rule))
			{
				counted += 1;
			}
		}
	}
	return count == counted;
}

private bool placedOn
(
	PropertyHistory history,
	int x, 
	int y,
	RuleIndex rule
)
{
	for (tuple[StepInfo stepInfo, 
			 ExtendedTileMaps mapState, 
			 list[bool] propteryStates] state <- history)
	{
		visit(state.mapState.ruleIndex)
		{
			case int i :
			{
				if (i == rule.index)
				{
					return true;
				}
			}
		}
	}
	return false;
}

public bool checkProperty
(
	adjecent(false, SymbolIndex tile, SymbolIndex adjecentTile), 
	PropertyHistory history,
	ExtendedTileMaps maps
)
{
	TileMap tileMap = maps.tileIndex;
	for (int y <- [0 .. size(tileMap)])
	{
		for (int x <- [0 .. size(tileMap[0])])
		{
			if (tileMap[y][x] == tile.index)
			{
				if (! ((tileMap[y-1][x] == adjecentTile.index)
						|| (tileMap[y+1][x] == adjecentTile.index)
						|| (tileMap[y][x-1] == adjecentTile.index)
						|| (tileMap[y][x+1] == adjecentTile.index)))
				{
				return false;
				}
			}
		}
	}
	return true;
}

public bool checkProperty
(
	adjecent(true, SymbolIndex tile, SymbolIndex adjecentTile), 
	PropertyHistory history,
	ExtendedTileMaps maps
)
{
	TileMap tileMap = maps.tileIndex;
	for (int y <- [0 .. size(tileMap)])
	{
		for (int x <- [0 .. size(tileMap[0])])
		{
			if (tileMap[y][x] == tile.index)
			{
				if (((tileMap[y-1][x] == adjecentTile.index)
					|| (tileMap[y+1][x] == adjecentTile.index)
					|| (tileMap[y][x-1] == adjecentTile.index)
					|| (tileMap[y][x+1] == adjecentTile.index)))
				{
				return false;
				}
			}
		}
	}
	return true;
}

