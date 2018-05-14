//////////////////////////////////////////////////////////////////////////////
//
// Implementation of MoAD (Metric of Added Detail)
// @brief        This file contains the data structures and the functions
//							 needed to evaluate the amount of detail that is added by each
//							 rule in a project.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         05-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module metrics::MoAD

import IO;
import List;
import parsing::DataStructures;
import execution::DataStructures;
import execution::ModuleHierarchy;

alias SymbolHierarchy = list[SymbolGroup];
alias SymbolGroup = set[int];

alias ProjectScore = map[str, ModuleScore];
alias ModuleScore = map[str, real];

public void calculateMoAD(LudoscopeProject project)
{
	ModuleHierarchy moduleHierarchy = (extractModuleHierarchy(project)).hierarchy;
	SymbolHierarchy symbolHierarchy = extractSymbolHierarchy(moduleHierarchy);
	ProjectScore projectScore = ();
	
	for (LudoscopeModule ludoscopeModule <- project.modules)
	{
		projectScore += 
			(ludoscopeModule.name : calculateModuleScore(ludoscopeModule, symbolHierarchy));
	}
	
	iprintln(projectScore);
	return;
}

private ModuleScore calculateModuleScore(
	LudoscopeModule ludoscopeModule, 
	SymbolHierarchy symbolHierarchy)
{
	return (rule : calculateRuleScore(symbolHierarchy, ludoscopeModule.rules[rule]) 
	| rule <- ludoscopeModule.rules);
}

private real calculateRuleScore(SymbolHierarchy symbolHierarchy, Rule rule)
{
	return 0.0;
}

private SymbolHierarchy extractSymbolHierarchy(ModuleHierarchy moduleHierarchy)
{
	SymbolHierarchy symbolHierarchy = [];
	SymbolGroup allUsedSymbols = {};
	for (set[LudoscopeModule] moduleGroup <- moduleHierarchy)
	{
		SymbolGroup newSymbolGroup = {};
		visit(moduleGroup)
		{
			case rule(Reflections reflections, TileMap leftHand, list[TileMap] rightHands) :
			{
				newSymbolGroup += extractNewSymbols(symbolHierarchy, rightHands) -
					allUsedSymbols;
			}
		}
		allUsedSymbols += newSymbolGroup;
		symbolHierarchy += [newSymbolGroup];
	}
	return symbolHierarchy;
}

private SymbolGroup extractNewSymbols(SymbolHierarchy hierarchy, list[TileMap] maps)
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