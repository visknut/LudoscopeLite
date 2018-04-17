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

public parsing::languages::recipe::AST::Recipe implodeRecipe(Tree tree)
  = implode(#parsing::languages::recipe::AST::Recipe, tree);
  
public parsing::languages::recipe::AST::Recipe parseRecipeToAST(loc location)
= implodeRecipe(parseRecipe(location));

//////////////////////////////////////////////////////////////////////////////
// AST
//////////////////////////////////////////////////////////////////////////////
		
data Recipe
	= recipe(list[Instruction] instructions);
	
data Instruction
	= setRegister(bool commented, str regsiterName, Expression newValue)
	| iterateRule(bool commented, str ruleName)
	| iterateFromRegister(bool commented, str registerName)
	| iterateRuleLSystem(bool commented, str ruleName)
	| iterateRuleCellular(bool commented, str ruleName)
	| executeFromRegister(bool commented, str ruleName, int executions)
	| executeRuleLSystem(bool commented, str ruleName, int executions)
	| executeRuleCellular(bool commented, str ruleName, int executions)
	| executeRule(bool commented, str ruleName, int executions)
	| replaceLabels(bool commented, str oldLabel, str newLabel)
	| splitTiles(bool commented, int width, int height)
	| createTileMapFromRegisters(bool commented, str registerWidth, str registerHeigth, str name)
	| createTileMapFromIntegers(bool commented, int mapWidth, int mapHeight, str name)
	| keepTopOfStack(bool commented)
	| transformSymbols(bool commented, str oldSymbol, str newSymbol); 
	
data Expression
	= expression(int newValue);