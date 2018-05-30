//////////////////////////////////////////////////////////////////////////////
//
// Framerwork for MAD (Metric of Added Detail)
// @brief        This file contains the data structures and the functions
//							 needed to evaluate the amount of detail that is added by each
//							 rule in a project using the MAD.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         05-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module analysis::madWrapper::MADFramework

import List;
import util::Integer;
import util::mad::Metric;

import parsing::DataStructures;
import execution::DataStructures;
import execution::ModuleHierarchy;

import analysis::madWrapper::SymbolHierarchy;
import analysis::madWrapper::DataTransformation;

alias ProjectScore = map[str, ModuleScore];
alias ModuleScore = map[str, list[RightHandScore]];
alias RightHandScore = tuple[int, HeatMap];
alias HeatMap = list[list[int]];

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
	return (ruleName : calculateRuleScore(symbolHierarchy, ludoscopeModule.rules[ruleName]) 
		| str ruleName <- ludoscopeModule.rules);
}

private list[RightHandScore] calculateRuleScore
(
	SymbolHierarchy symbolHierarchy, 
	Rule rule
)
{
	list[RightHandScore] rightHandScores = [];
	Detail detail = symbolHierarchyToDetail(symbolHierarchy);
	list[MadRuleMap] madRuleMaps = 
		ludoscopeRuleToMadRuleMaps(rule);
	
	list[MadRuleScoreMap] madRuleScores = 
		[ <madRuleMap.width, getRuleScore(madRuleMap.rule, detail)>
		| MadRuleMap madRuleMap <- madRuleMaps];
	
	return madRuleScoreMapToRightHandScores(madRuleScores);
}