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

alias Tile = int;
alias TileMap = list[list[Tile]];
alias Alphabet = map[str, int];
alias AlphabetMap = map[str, Alphabet];
alias RuleMap	= map[str, Rule];

data ProjectInformation
	= projectInformation(LudoscopeProject project, loc projectFile);

data LudoscopeProject
	= ludoscopeProject(list[LudoscopeModule] modules, 
	AlphabetMap alphabets);
	
data LudoscopeModule
	= ludoscopeModule(str name,
	list[str] inputs,
	str alphabetName,
	TileMap startingState, 
	RuleMap rules, 
	list[Instruction] recipe);
	
data Rule
	= rule(Topology topology, 
	TileMap leftHand, 
	list[TileMap] rightHands);
	
data Topology
	= topology(bool mirrorHorizontal, 
	bool mirrorVertical, 
	bool rotate);
	
data Instruction
	= itterateRule(str ruleName)
	| executeRule(str ruleName, int itterations);