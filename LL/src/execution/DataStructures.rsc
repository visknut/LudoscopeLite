//////////////////////////////////////////////////////////////////////////////
//
// Execution Data Structures
// @brief        This file contains datastructures needed for execution an LL
//							 project.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         01-05-2018
//
//////////////////////////////////////////////////////////////////////////////

module execution::DataStructures

import analysis::sanrWrapper::PropertyHistory;
import sanr::PropertyValidation;
//import execution::history::DataStructures;
import parsing::DataStructures;
import errors::Execution;

import sanr::DataStructures;

alias OutputMap = map[str, TileMap];
alias ModuleHierarchy = list[set[LudoscopeModule]];
alias Location =  tuple[int x, int y];

data ExecutionArtifact =
	executionArtifact(OutputMap output,
										TileMap currentState,
										ExecutionHistory history,
										PropertyReport propertyReport,
										list[ExecutionError] errors)
	| emptyExecutionArtifact();
	
data PreparationArtifact =
	preparationArtifact(ModuleHierarchy hierarchy, list[ExecutionError] errors)
	| emptyPreparationArtifact();
	
alias ExecutionHistory = list[Step];

data Step = 
	step(TileMap tileMap, 
			str moduleName, 
			Instruction instruction, 
			str ruleName, 
			int rightHand, 
			Coordinates location);