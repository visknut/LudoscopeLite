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

start syntax Alphabet
	= alphabet: MapType Symbol*;
	
syntax MapType
	= tileMap: "TILEMAP" INTEGER INTEGER
	| string: "STRING"
	| graph: "GRAPH"
	| shape: "SHAPE";
	
syntax Symbol
	= symbol: NAME "(" 
	"color" COLORCODE
	"fill" COLORCODE
	("abbreviation" String)?
	("shape" INTEGER)?
	")";
	
syntax String
  = "\"" STRING "\"";

lexical NAME
  = ([a-zA-Z_$] [a-zA-Z0-9_$]* !>> [a-zA-Z0-9_$]) \ Keyword
  | "*";

lexical COLORCODE
	= "#" [0-9A-F] [0-9A-F] [0-9A-F] [0-9A-F] [0-9A-F] [0-9A-F];
 
lexical INTEGER
  = "-"?[0-9]+;
  
lexical STRING
  = ![\"]*;

layout LAYOUTLIST
  = LAYOUT* !>> [\t-\n \r \ : , =];

lexical LAYOUT
  =  [\t-\n \r \ : , =];
  
keyword Keyword
  = "color"
  | "fill"
  | "abbreviation"
  | "shape"
  | "TILEMAP"
  | "STRING"
  | "GRAPH"
  | "SHAPE";
  
//////////////////////////////////////////////////////////////////////////////
// API
//////////////////////////////////////////////////////////////////////////////

public start[Alphabet] parseAlphabet(loc file) = 
  parse(#start[Alphabet], file);