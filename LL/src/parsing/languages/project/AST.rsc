//////////////////////////////////////////////////////////////////////////////
//
// The AST used for parsing .lsp files.
// @brief        This file contains the data structure needed for imploding
//							 a parsed .lsp tree.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         03-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::languages::project::AST

import parsing::languages::project::Syntax;
import ParseTree;

//////////////////////////////////////////////////////////////////////////////
// APIs
//////////////////////////////////////////////////////////////////////////////

public parsing::languages::project::AST::Project implodeProject(Tree tree)
  = implode(#parsing::languages::project::AST::Project, tree);
  
public parsing::languages::project::AST::Project parseProjectToAST(loc location)
  = implodeProject(parseProject(location));

//////////////////////////////////////////////////////////////////////////////
// AST
//////////////////////////////////////////////////////////////////////////////
		
data Project
	= project(str version, list[Declaration] declarations);
	
data Declaration
	= declaredAlphabet(Alphabet declaredAlphabet)
	| declaredModule(Module declaredModule)
	| declaredOption(Option declaredOption)
	| declaredRegister(Register declaredRegister);

data Alphabet 
	= alphabet(str name, Position position);

data Module 
	= lspmodule(str name,
	str alphabet,
	str position,
	str moduleType,
	str fileName,
	str match,
	list[str] inputs,
	str maxIterations,
	str moduleFilter,
	str grammar,
	str executionType,
	str recipe,
	str showMembers,
	str alwaysStartWithToken);

data Register 
	= register(Variable registerContent);

data Option 
	= option(Variable optionContent);

data Variable
	= variableInteger(str name, int integer)
	| variableFloat(str name, str float)
	| variableString(str name, str string)
	| variableList(str name, list[str] listOfVariable)
	| variableBoolean(str name, bool boolean)	
	| variablePosition(str name, Position position)
	| variableName(str name, str variableName)
	| variableNull(str name);

data Position 
	= position(int x, int y);