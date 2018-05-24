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

import errors::Parsing;
import lpl::DataStructures;

alias TileMap = list[list[Tile]];
alias Tile = int;

alias SymbolNameList = list[str];
alias AlphabetMap = map[str, SymbolNameList];
alias ModuleNameList = list[str];
alias RuleNameList = list[str];
alias RuleMap	= map[int, Rule];
alias Recipe = list[Instruction];

data TransformationArtifact
	= transformationArtifact(LudoscopeProject project, 
		list[ParsingError] errors);

data LudoscopeProject
	= ludoscopeProject(list[LudoscopeModule] modules, 
		AlphabetMap alphabets,
		ModuleNameList moduleNames,
		RuleNameList ruleNames,
		list[Property] properties)
	| undefinedProject();
	
data LudoscopeModule
	= ludoscopeModule(int nameIndex,
		list[int] inputs,
		str alphabetName,
		TileMap startingState, 
		RuleMap rules, 
		Recipe recipe)
	| unfinishedLudoscopeModule(int nameIndex,
		list[str] inputStrings,
		str alphabetName,
		TileMap startingState, 
		RuleMap rules, 
		Recipe recipe)
	| undefinedModule();
	
data Rule
	= rule(Reflections reflections, 
		TileMap leftHand, 
		list[TileMap] rightHands);
	
data Reflections
	= reflections(bool mirrorHorizontal, 
		bool mirrorVertical, 
		bool rotate);
		
data Coordinates
	= coordinates(int x, int y);

data Instruction
	= itterateRule(int ruleNameIndex)
	| executeRule(int ruleNameIndex, int itterations)
	| executeGrammar();