/*****************************************************************************/
/*!
* RCP (Ludoscope recipe) Abstract Syntax
* @package      parsing::lang::rcp
* @file         AST.rsc
* @brief        Defines Ludoscope Recipe Abstract Syntax
* @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
* @date         March 3th 2018
* @note         Language: Rascal
*/
/*****************************************************************************/
module parsing::lang::rcp::AST

import parsing::lang::rcp::Syntax;
import ParseTree;

/***************************************************************************** 
 * Public APIs
 *****************************************************************************/
public lang::rcp::AST::RCP rcp_implode(Tree tree)
  = implode(#parsing::lang::rcp::AST::RCP, tree);

/***************************************************************************** 
 * Source location annotations
 *****************************************************************************/
anno loc RCP@location;

/***************************************************************************** 
 * LSP (Ludoscope Project) AST
 *****************************************************************************/			
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