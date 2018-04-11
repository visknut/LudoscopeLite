//////////////////////////////////////////////////////////////////////////////
//
// Syntax for .rcp files.
// @brief        This files contains the syntax needed for parsing .rcp files.
//							 .rcp files contain the recipe that is used to execute a grammar.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         03-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::languages::recipe::Syntax

import ParseTree;

//////////////////////////////////////////////////////////////////////////////
// Parser Rules
////////////////////////////////////////////////////////////////////////////// 

start syntax Recipe
  = recipe: Commands*;
  
syntax Commands
  = setRegister: 								COMMENTED? "SetRegister" "(" String Expression ")" // TODO: registers can hold mutiple values, including expressions.
  | iterateRule: 								COMMENTED? "IterateRule" "(" String ")"
  | iterateFromRegister: 				COMMENTED? "IterateFromRegister" "(" String ")"
  | iterateRuleLSystem:					COMMENTED? "IterateRuleLSystem" "(" String ")"
  | iterateRuleCellular: 				COMMENTED? "IterateRuleCellular" "(" String ")"
  | executeFromRegister: 				COMMENTED? "ExecuteFromRegister" "(" String INTEGER ")" // TODO: executions can also use the dice notation. (for example 'D2')
  | executeRuleLSystem: 				COMMENTED? "ExecuteRuleLSystem" "(" String INTEGER ")"
  | executeRuleCellular: 				COMMENTED? "ExecuteRuleCellular" "(" String INTEGER ")"
  | executeRule: 								COMMENTED? "ExecuteRule" "(" String INTEGER ")"
  | splitTiles: 								COMMENTED? "SplitTiles" "(" INTEGER INTEGER ")"
  | replaceLabels: 							COMMENTED? "ReplaceLabels" "(" String String")"
  | keepTopOfStack: 						COMMENTED? "KeepTopOfStack"
  | createTileMapFromRegisters: COMMENTED? "CreateTileMap" "(" NAME NAME String ")"
  | createTileMapFromIntegers:	COMMENTED? "CreateTileMap" "(" INTEGER INTEGER String ")"
  | transformSymbols:						COMMENTED? "TransformSymbols" "(" String String ")";

syntax String
  = "\"" STRING "\"";
  
syntax Expression
	= expression: INTEGER; // TODO: what is allowed to be in registers?
  
//////////////////////////////////////////////////////////////////////////////
// Lexer Rules
//////////////////////////////////////////////////////////////////////////////

 // TODO: Add dice notation.

lexical NAME
  = ([a-zA-Z_$*] [a-zA-Z0-9_$*]* !>> [a-zA-Z0-9_$*]) \ Keyword;

lexical INTEGER
  = ("-"?[0-9]+);

lexical STRING
  = ![\"]*;
  
lexical COMMENTED
	= "//";

//////////////////////////////////////////////////////////////////////////////
// Layout
////////////////////////////////////////////////////////////////////////////// 

layout LAYOUTLIST
  = LAYOUT* !>> [\t-\n \r \ : ,];

lexical LAYOUT
  =  [\t-\n \r \ : ,];
  
keyword Keyword
  = "SetRegister"
  | "IterateRule"
  | "IterateFromRegister"
  | "IterateRuleLSystem"
  | "IterateRuleCellular"
  | "ExecuteFromRegister"
  | "ExecuteRuleLSystem"
  | "ExecuteRuleCellular"
  | "ExecuteRule"
  | "ReplaceLabels"
  | "SplitTiles"
  | "TransformSymbols"
  | "CreateTileMap"
  | "KeepTopOfStack";
  
//////////////////////////////////////////////////////////////////////////////
// API
//////////////////////////////////////////////////////////////////////////////
  
public start[Recipe] parseRecipe(loc file) = 
  parse(#start[Recipe], file);