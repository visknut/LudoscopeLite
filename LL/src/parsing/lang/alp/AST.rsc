/*****************************************************************************/
/*!
* ALP (Ludoscope Alphabet) Abstract Syntax
* @package      parsing::lang::alp
* @file         AST.rsc
* @brief        Defines Ludoscope Alphabet Abstract Syntax
* @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
* @date         March 9th 2018
* @note         Language: Rascal
*/
/*****************************************************************************/
module parsing::lang::alp::AST

import parsing::lang::alp::Syntax;
import ParseTree;

/***************************************************************************** 
 * Public APIs
 *****************************************************************************/
public parsing::lang::alp::AST::ALP alp_implode(Tree tree)
  = implode(#parsing::lang::alp::AST::ALP, tree);
  
public parsing::lang::alp::AST::ALP parseToAST(loc location)
  = alp_implode(alp_parse(location));

/***************************************************************************** 
 * Source location annotations
 *****************************************************************************/
anno loc ALP@location;

/***************************************************************************** 
 * LSP (Ludoscope Project) AST
 *****************************************************************************/			
data ALP 
	= alp(MapType mapType, list[Symbol] symbols);
	
data MapType
	= mapType(int width, int height);
	
data Symbol
	= symbol(str name, str color, str fill, str abbreviation)
	| symbolWithShape(str name, str color, str fill, str abbreviation, int shape);