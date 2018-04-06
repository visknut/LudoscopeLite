//////////////////////////////////////////////////////////////////////////////
//
// Syntax for .alp files.
// @brief        This files contains the syntax needed for parsing .alp files.
//							 .alp files contain the symbols that are used in a module.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         03-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::languages::alphabet::Syntax

import ParseTree;

//////////////////////////////////////////////////////////////////////////////
// Syntax
//////////////////////////////////////////////////////////////////////////////  

start syntax ALP
	= alp: MapType Symbol*;
	
syntax MapType
	= mapType: "TILEMAP" VALUE VALUE;
	
syntax Symbol
	= symbol: IDENTIFIER "(" Color Color Abbreviation ")"
	| symbolWithShape: IDENTIFIER "(" Color Color Abbreviation Shape ")"; // TODO: implement wildcard symbol.

syntax Color
	= ("color" | "fill") "=" COLORCODE;
	
syntax Abbreviation
	= "abbreviation" "=" String;
	
syntax Shape
	= "shape" "=" VALUE;

syntax String
  = @category="String"  "\"" STRING "\""; // TODO: How to clean \" form the string in parser?
    
syntax IDENTIFIER
  = indentifier: NAME;

lexical NAME
  = ([a-zA-Z_$] [a-zA-Z0-9_$]* !>> [a-zA-Z0-9_$]) \ Keyword;

lexical COLORCODE
	= "#" [0-9A-Z]*;
 
lexical VALUE
  = @category="Value" ("-"?[0-9]+([.][0-9]+?)?); // TODO: check IDE for coloring.
  
lexical STRING
  = ![\"]*;

layout LAYOUTLIST
  = LAYOUT* !>> [\t-\n \r \ : ,];

lexical LAYOUT
  =  [\t-\n \r \ : ,];
  
keyword Keyword
  = "color"
  | "fill"
  | "abbreviation"
  | "shape"
  | "TILEMAP";
  
//////////////////////////////////////////////////////////////////////////////
// API
//////////////////////////////////////////////////////////////////////////////

public start[ALP] parseAlphabet(loc file) = 
  parse(#start[ALP], file);