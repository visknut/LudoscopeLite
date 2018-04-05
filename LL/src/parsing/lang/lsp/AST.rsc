/*****************************************************************************/
/*!
* LSP (Ludoscope Project) Abstract Syntax
* @package      parsing::lang::lsp
* @file         AST.rsc
* @brief        Defines Ludoscope Project Abstract Syntax
* @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
* @date         March 2th 2018
* @note         Language: Rascal
*/
/*****************************************************************************/
module parsing::lang::lsp::AST

import parsing::lang::lsp::Syntax;
import ParseTree;

/***************************************************************************** 
 * Public APIs
 *****************************************************************************/
public lang::lsp::AST::LSP lsp_implode(Tree tree)
  = implode(#parsing::lang::lsp::AST::LSP, tree);

/***************************************************************************** 
 * Source location annotations
 *****************************************************************************/
anno loc LSP@location;

/***************************************************************************** 
 * LSP (Ludoscope Project) AST
 *****************************************************************************/			
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