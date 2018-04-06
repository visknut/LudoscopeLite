//////////////////////////////////////////////////////////////////////////////
//
// The data structures for a LL project
// @brief        This file contains the data structures needed for executing
//							 the modules in a Ludoscope Light project.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         05-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::DataStructures

// TODO add alias
// TODO: add registers & options
data LudoscopeProject
	= ludoscopeProject(list[LudoscopeModule] modules, list[map[str, int]] alphabets);
	
data LudoscopeModule
	= ludoscopeModule(LudoscopeModule input, list[list[int]] startingState, list[Rule] rules, list[Instruction] recipe); // aplhabet
	
data Rule
	= rule(int width, int height, bool rotateHorizontal, bool rotateVertical, list[list[int]] leftHand, list[list[int]] rightHands);
	
data Instruction
	= itterateRule(Rule rule)
	| executeRule(Rule rule, int itterations);