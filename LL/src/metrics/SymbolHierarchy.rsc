//////////////////////////////////////////////////////////////////////////////
//
// Extracting symbol hierarchy
// @brief        This file contains functions to extract the symbol hierarchy
//							 from a project.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         17-05-2018
//
//////////////////////////////////////////////////////////////////////////////

module metrics::SymbolHierarchy

import List;
import parsing::DataStructures;
import execution::DataStructures;

alias SymbolHierarchy = list[SymbolGroup];
alias SymbolGroup = set[int];

public SymbolHierarchy extractSymbolHierarchy(ModuleHierarchy moduleHierarchy)
{
	SymbolHierarchy symbolHierarchy = [];
	SymbolGroup allUsedSymbols = {};
	SymbolGroup newSymbolGroup = {};
	
	/* Begin with extract the symbols from the starting state (multiple starts possible). */
	for (LudoscopeModule currentModule <- head(moduleHierarchy))
	{
		newSymbolGroup += extractNewSymbols(symbolHierarchy, [currentModule.startingState]);
	}
	allUsedSymbols += newSymbolGroup;
	symbolHierarchy += [newSymbolGroup];
	
	/* Extract the symbols from the right hands of rules. */
	for (set[LudoscopeModule] moduleGroup <- moduleHierarchy)
	{
		newSymbolGroup = {};
		visit(moduleGroup)
		{
			case rule
			(
				Reflections reflections, 
				TileMap leftHand, 
				list[TileMap] rightHands
			) :
			{
				newSymbolGroup += extractNewSymbols(symbolHierarchy, rightHands) -
					allUsedSymbols;
			}
		}
		if (newSymbolGroup != {})
		{
			allUsedSymbols += newSymbolGroup;
			symbolHierarchy += [newSymbolGroup];
		}
	}
	return symbolHierarchy;
}

private SymbolGroup extractNewSymbols
(
	SymbolHierarchy hierarchy, 
	list[TileMap] maps
)
{
	SymbolGroup usedSymbols = {};
	visit (maps)
	{
		case int symbol:
		{
			usedSymbols += symbol;
		}
	}
	return usedSymbols;
}