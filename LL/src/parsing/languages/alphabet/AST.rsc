//////////////////////////////////////////////////////////////////////////////
//
// The AST used for parsing .alp files.
// @brief        This file contains the data structure needed for imploding
//							 a parsed .alp tree.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         03-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::languages::alphabet::AST

import parsing::languages::alphabet::Syntax;
import ParseTree;

//////////////////////////////////////////////////////////////////////////////
// APIs
//////////////////////////////////////////////////////////////////////////////

public parsing::languages::alphabet::AST::Alphabet implodeAlphabet(Tree tree)
  = implode(#parsing::languages::alphabet::AST::Alphabet, tree);
  
public parsing::languages::alphabet::AST::Alphabet parseAlphabetToAST(loc location)
  = implodeAlphabet(parseAlphabet(location));
  
anno loc Alphabet@location;
anno loc MapType@location;
anno loc Symbol@location;

//////////////////////////////////////////////////////////////////////////////
// AST
//////////////////////////////////////////////////////////////////////////////
		
data Alphabet
	= alphabet(MapType mapType, list[Symbol] symbols);
	
data MapType
	= tileMap(int width, int height)
	|	string()
	|	graph()
	|	shape();

data Symbol
	= symbol(str name, str color, str fill, str abbreviation, str shape); // TODO: accept shape as int