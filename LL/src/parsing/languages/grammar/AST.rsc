//////////////////////////////////////////////////////////////////////////////
//
// The AST used for parsing .grm files.
// @brief        This file contains the data structure needed for imploding
//							 a parsed .grm tree.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         03-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::languages::grammar::AST

import parsing::languages::grammar::Syntax;
import ParseTree;

//////////////////////////////////////////////////////////////////////////////
// APIs
//////////////////////////////////////////////////////////////////////////////

public parsing::languages::grammar::AST::GRM implodeGrammar(Tree tree)
  = implode(#parsing::languages::grammar::AST::GRM, tree);
  
public parsing::languages::grammar::AST::GRM parseGrammarToAST(loc location)
= implodeGrammar(parseGrammar(location));

//////////////////////////////////////////////////////////////////////////////
// AST
//////////////////////////////////////////////////////////////////////////////
		
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