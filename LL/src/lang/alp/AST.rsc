/*****************************************************************************/
/*!
* ALP (Ludoscope Alphabet) Abstract Syntax
* @package      lang::alp
* @file         AST.rsc
* @brief        Defines Ludoscope Alphabet Abstract Syntax
* @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
* @date         March 9th 2018
* @note         Language: Rascal
*/
/*****************************************************************************/
module lang::alp::AST

import lang::alp::Syntax;
import ParseTree;

/***************************************************************************** 
 * Public APIs
 *****************************************************************************/
public lang::alp::AST::ALP alp_implode(Tree tree)
  = implode(#lang::alp::AST::ALP, tree);

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