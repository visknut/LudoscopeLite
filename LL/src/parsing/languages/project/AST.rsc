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

public parsing::languages::project::AST::LSP implodeProject(Tree tree)
  = implode(#parsing::languages::project::AST::LSP, tree);
  
public parsing::languages::project::AST::LSP parseProjectToAST(loc location)
  = implodeProject(parseProject(location));

//////////////////////////////////////////////////////////////////////////////
// AST
//////////////////////////////////////////////////////////////////////////////
		
data LSP 
	= lsp(list[Alphabet] alphabets, list[Module] modules, list[var] registers, list[var] options);

data Alphabet 
	= alphabet(list[var]);

data Module 
	= lspmodule(list[var]);

data Register 
	= register(var content);

data Option 
	= option(var content);

data var 
	= varInt(str name, int intVal)
	| varList(str name, list[str] listVal)
	| varStr(str name, str strVal)
	| varBool(str name, bool boolVal)
	| varPos(str name, pos posVal)	
	| varMisc(str name, str miscVal)
	| varNull(str name);

data pos 
	= position(int x, int y);