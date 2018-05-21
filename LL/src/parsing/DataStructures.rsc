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

alias Tile = int;
alias TileMap = list[list[Tile]];
alias Alphabet = map[str, int];
alias AlphabetMap = map[str, Alphabet];
alias RuleMap	= map[str, Rule];
alias Recipe = list[Instruction];

data TransformationArtifact
	= transformationArtifact(LudoscopeProject project, 
		list[ParsingError] errors);

data LudoscopeProject
	= ludoscopeProject(list[LudoscopeModule] modules, 
		AlphabetMap alphabets,
		list[Property] properties)
	| undefinedProject();
	
data LudoscopeModule
	= ludoscopeModule(str name,
		list[str] inputs,
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
	= itterateRule(str ruleName)
	| executeRule(str ruleName, int itterations)
	| executeGrammar();

///////////////////////////////////////////////////////////////////////////////
// Lpl data.
///////////////////////////////////////////////////////////////////////////////

data Property
	= containment(Structure containedStructure, Structure container)
	| containment(Symbol containedSybmol, Structure container);
	
data Structure
	= moduleStrucutre(str moduleName)
	| ruleStructure(str ruleName)
	| undefinedStructure();
	
data Symbol
	= symbol(str symbolName);