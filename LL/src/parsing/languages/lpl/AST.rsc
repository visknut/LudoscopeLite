//////////////////////////////////////////////////////////////////////////////
//
// The AST used for parsing .lpl files.
// @brief        This file contains the data structure needed for imploding
//							 a parsed .lpl tree.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         18-05-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::languages::lpl::AST

import parsing::languages::lpl::Syntax;
import ParseTree;

//////////////////////////////////////////////////////////////////////////////
// APIs
//////////////////////////////////////////////////////////////////////////////

public parsing::languages::lpl::AST::Properties implodeLpl(Tree tree)
  = implode(#parsing::languages::lpl::AST::Properties, tree);
  
public parsing::languages::lpl::AST::Properties parseLplToAST(loc location)
	= implodeLpl(parseLpl(location));

//////////////////////////////////////////////////////////////////////////////
// AST
//////////////////////////////////////////////////////////////////////////////

anno loc Property@location;

data Properties
	= properties(list[Property]);
	
data Property
	= occurrence(int count, str containted, str container)
	| adjecent(str tile, str adjecentTile);