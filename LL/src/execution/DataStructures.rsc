//////////////////////////////////////////////////////////////////////////////
//
// Language Registration
// @brief        This file contains datastructures needed for execution an LL
//							 project.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         01-05-2018
//
//////////////////////////////////////////////////////////////////////////////

module execution::DataStructures

import parsing::DataStructures;
import errors::Execution;

alias OutputMap = map[str, TileMap];
alias ModuleHierarchy = list[set[LudoscopeModule]];

data ExecutionArtifact =
	executionArtifact(OutputMap output, list[ExecutionError] errors);
	
data PreparationArtifact =
	preparationArtifact(ModuleHierarchy hierarchy, list[ExecutionError] errors);