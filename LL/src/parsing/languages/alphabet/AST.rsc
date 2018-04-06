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

public parsing::languages::alphabet::AST::ALP implodeAlphabet(Tree tree)
  = implode(#parsing::languages::alphabet::AST::ALP, tree);
  
public parsing::languages::alphabet::AST::ALP parseAlphabetToAST(loc location)
  = implodeAlphabet(parseAlphabet(location));

//////////////////////////////////////////////////////////////////////////////
// AST
//////////////////////////////////////////////////////////////////////////////
		
data ALP 
	= alp(MapType mapType, list[Symbol] symbols);
	
data MapType
	= mapType(int width, int height);
	
data Symbol
	= symbol(str name, str color, str fill, str abbreviation)
	| symbolWithShape(str name, str color, str fill, str abbreviation, int shape);