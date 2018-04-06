//////////////////////////////////////////////////////////////////////////////
//
// Syntax for .grm files.
// @brief        This files contains the syntax needed for parsing .grm files.
//							 .grm files contain the grammar of a module.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         03-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::languages::grammar::Syntax

import ParseTree;

//////////////////////////////////////////////////////////////////////////////
// Syntax
//////////////////////////////////////////////////////////////////////////////  

start syntax GRM
	= grm: "version" ":" NAME Start Rule*;
	
syntax Start
  = startmap: "start" ":" MAPTYPE VALUE VALUE Tile*;
  
syntax Rule
	= rule: "rule" ":" IDENTIFIER Settings? "=" LeftHand "\>" RightHand+;
	
syntax LeftHand
	= leftHand: MAPTYPE VALUE VALUE Tile*;
	
syntax RightHand
	= rightHand: "{" VALUE Expression? "=" MAPTYPE VALUE VALUE Tile* "}";
	
syntax Settings
	= settings: "(" ("width" "=" VALUE)? ("height" "=" VALUE)? ("gt" "=" VALUE)? ")";
  
syntax Tile
	= tile: VALUE ":" IDENTIFIER Expression?;
	
syntax Expression
  = expression: "(" STRING ")"; // TODO: implement expressions.

syntax String
  = @category="String"  "\"" STRING "\""; // TODO: How to clean \" form the string in parser?
    
syntax MAPTYPE
  = maptype: "TILEMAP"; // TODO: accept multiple map types.

syntax IDENTIFIER
  = indentifier: NAME;

lexical NAME
  = ([a-zA-Z0-9_$.*] [a-zA-Z0-9_$.*]* !>> [a-zA-Z0-9_$.*]) \ Keyword;

lexical COLORCODE
	= "#" [0-9A-Z]*;
 
lexical VALUE
  = @category="Value" ("-"?[0-9]+([.][0-9]+?)?); // TODO: Meaning @category?
  
lexical STRING
  = ![\"]*;

layout LAYOUTLIST
  = LAYOUT* !>> [\t-\n \r \ , |];

lexical LAYOUT
  =  [\t-\n \r \ : , { } ( ) \> = |];
  
keyword Keyword
  = "version"
  | "start"
  | "rule"
  | "TILEMAP"
  | "width"
  | "height"
  | "gt";
  
//////////////////////////////////////////////////////////////////////////////
// API
//////////////////////////////////////////////////////////////////////////////
  
public start[GRM] parseGrammar(loc file) = 
  parse(#start[GRM], file);