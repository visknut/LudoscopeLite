//////////////////////////////////////////////////////////////////////////////
//
// The AST used for parsing .rcp files.
// @brief        This file contains the data structure needed for imploding
//							 a parsed .rcp tree.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         03-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::languages::recipe::AST

import parsing::languages::recipe::Syntax;
import ParseTree;

//////////////////////////////////////////////////////////////////////////////
// APIs
//////////////////////////////////////////////////////////////////////////////

public parsing::languages::recipe::AST::RCP implodeRecipe(Tree tree)
  = implode(#parsing::languages::recipe::AST::RCP, tree);
  
public parsing::languages::recipe::AST::RCP parseRecipeToAST(loc location)
= implodeRecipe(rcp_parse(location));

//////////////////////////////////////////////////////////////////////////////
// AST
//////////////////////////////////////////////////////////////////////////////
		
data RCP
	= rcp(list[cmd] commands);
	
data cmd
	= setRegister(str name, int newValue)
	| iterateRule(str name)
  	| iterateFromRegister(str name)
  	| iterateRuleLSystem(str name)
  	| iterateRuleCellular(str name)
  	| executeFromRegister(str name, int executions)
  	| executeRuleLSystem(str name, int executions)
  	| executeRuleCellular(str name, int executions)
  	| executeRule(str name, int executions)
  	| replaceLabels(str oldLabel, str newLabel)
  	| splitTiles(int width, int height)
  	| createTileMap(str mapWidth, str mapHeight, str name)
  	| keepTopOfStack();