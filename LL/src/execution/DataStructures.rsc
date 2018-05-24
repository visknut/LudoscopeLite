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

import analysis::lplWrapper::PropertyHistory;
import lpl::PropertyValidation;
import execution::history::DataStructures;
import parsing::DataStructures;
import errors::Execution;

import lpl::DataStructures;

alias OutputMap = map[int, TileMap];
alias ModuleHierarchy = list[set[LudoscopeModule]];
alias Location =  tuple[int x, int y];

data ExecutionArtifact =
	executionArtifact(OutputMap output,
										TileMap currentState,
										ExecutionHistory history,
										PropertyReport propertyReport,
										list[ExecutionError] errors);
	
data PreparationArtifact =
	preparationArtifact(ModuleHierarchy hierarchy, list[ExecutionError] errors);
	
alias ExecutionHistory = list[ModuleExecution];

data ModuleExecution 
	= moduleExecution(int nameIndex, list[InstructionExecution] instructions);
	
data InstructionExecution
	= instructionExecution(list[RuleExecution] rules);
	
data RuleExecution 
	= ruleExecution(int nameIndex, int rightHandIndex, Coordinates location);