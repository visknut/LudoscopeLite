/*****************************************************************************/
/*!
* GRM (Ludoscope Grammar) Abstract Syntax
* @package      parsing::lang::grm
* @file         AST.rsc
* @brief        Defines Ludoscope Grammar Abstract Syntax
* @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
* @date         March 9th 2018
* @note         Language: Rascal
*/
/*****************************************************************************/
module parsing::lang::grm::AST

import parsing::lang::grm::Syntax;
import ParseTree;

/***************************************************************************** 
 * Public APIs
 *****************************************************************************/
public parsing::lang::grm::AST::GRM grm_implode(Tree tree)
  = implode(#parsing::lang::grm::AST::GRM, tree);
  
public parsing::lang::grm::AST::GRM parseToAST(loc location)
= grm_implode(grm_parse(location));
  

/***************************************************************************** 
 * Source location annotations
 *****************************************************************************/
anno loc GRM@location;

/***************************************************************************** 
 * LSP (Ludoscope Project) AST
 *****************************************************************************/			
data GRM
	= grm(str name, Start strmap, list[Rule] rules);
	
data Start
 = startmap(str maptype, int width, int height, list[Tile] tiles);
 
data Tile
	= tile(int identifier, str label, str expression);
	
data Rule
	= rule(str name, Settings settings, LeftHand leftHand, list[RightHand] rightHand);
	
data Lefthand
	= leftHand(str maptype, int width, int height, list[Tile] tiles);

data Righthand
	= rightHand(int indertifier, str expression, str maptype, int width, int height, list[Tile] tiles);
	
data Settings
	= settings(str width, str height, str gt);// TODO: read them as strings.