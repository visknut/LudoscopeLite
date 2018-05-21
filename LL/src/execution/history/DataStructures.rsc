//////////////////////////////////////////////////////////////////////////////
//
// Data structures for check properties.
// @brief        This file contains the data structures needed in checking the
//							 properties declared in the project.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         20-06-2018
//
//////////////////////////////////////////////////////////////////////////////

module execution::history::DataStructures

import parsing::DataStructures;

alias ExecutionHistory = list[ModuleExecution];

data ModuleExecution 
	= moduleExecution(str name, list[InstructionExecution] instructions);
	
data InstructionExecution
	= instructionExecution(list[RuleExecution] rules);
	
data RuleExecution 
	= ruleExecution(str name, int rightHandIndex, Coordinates location);