/*****************************************************************************/
/*!
* GRM (Ludoscope Grammar) Abstract Syntax
* @package      lang::grm
* @file         AST.rsc
* @brief        Defines Ludoscope Grammar Abstract Syntax
* @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
* @date         March 9th 2018
* @note         Language: Rascal
*/
/*****************************************************************************/
module lang::grm::AST

import lang::grm::Syntax;
import ParseTree;

/***************************************************************************** 
 * Public APIs
 *****************************************************************************/
public lang::grm::AST::GRM grm_implode(Tree tree)
  = implode(#lang::grm::AST::GRM, tree);

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
	= rule(str name, Settings settings, Righthand right, list[Lefthand] left);
	
data Righthand
	= righthand(str maptype, int width, int height, list[Tile] tiles);

data Lefthand
	= lefthand(int indertifier, str expression, str maptype, int width, int height, list[Tile] tiles);
	
data Settings
	= settings(str width, str height, str gt);// TODO: read them as strings.