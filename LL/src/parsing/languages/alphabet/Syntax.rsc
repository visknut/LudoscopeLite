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
	= alphabet: MapType SymbolInfo*;
	
syntax MapType
	= tileMap: "TILEMAP" INTEGER width INTEGER height
	| string: "STRING"
	| graph: "GRAPH"
	| shape: "SHAPE";

// TODO: use variable names (as in SAnR).	
syntax SymbolInfo
	= symbolInfo: NAME name "(" 
	"color" COLORCODE color
	"fill" COLORCODE fill
	("abbreviation" String abbreviation)?
	("shape" INTEGER shape)?
	")";
	
syntax String
  = @category="String" "\"" STRING "\"";

//////////////////////////////////////////////////////////////////////////////
// Lexer Rules
//////////////////////////////////////////////////////////////////////////////

lexical NAME
  = @category="Name" ([a-zA-Z_$] [a-zA-Z0-9_$]* !>> [a-zA-Z0-9_$]) \ Keyword
  | @category="Name" "*";

lexical COLORCODE
	= @category="ColorCode" "#" [0-9A-F] [0-9A-F] [0-9A-F] [0-9A-F] [0-9A-F] [0-9A-F];
 
lexical INTEGER
  = "-"?[0-9]+;
  
lexical STRING
  = ![\"]*;

//////////////////////////////////////////////////////////////////////////////
// Layout
//////////////////////////////////////////////////////////////////////////////

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
  
public start[Alphabet] parseAlphabet(str input, loc location) 
{ 
	return parse(#start[Alphabet], input, location); 
}