//////////////////////////////////////////////////////////////////////////////
//
// Syntax for .lsp files.
// @brief        This files contains the syntax needed for parsing .lsp files.
// 							 .lsp files contain the structure of a ludoscope project.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         03-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::languages::project::Syntax

import ParseTree;

//////////////////////////////////////////////////////////////////////////////
// Syntax
//////////////////////////////////////////////////////////////////////////////  

start syntax LSP
	= lsp: Alphabet* Module* ("register" Variable)* ("option" Variable)*;

syntax Alphabet
	= alphabet: "alphabet" Variable*;

syntax Module
  = lspmodule: "module" Variable*;

syntax Variable
	= varInt: 	NAME VALUE
	| varStr:		NAME String
	| varList: 	NAME "[" String* "]" // List of strings without brackets.
	| varBool: 	NAME BOOLEAN
	| varPos:		NAME Position
	| varMisc:	NAME NAME
	| varNull: 	NAME "null";
  
syntax String
  = @category="String"  "\"" STRING "\""; // TODO: How to clean \" form the string in parser?
    
syntax IDENTIFIER
  = indentifier: NAME;
  
syntax Position
  = position: "(" VALUE VALUE ")";
  
lexical BOOLEAN
  = @category="Boolean" "true" | "false";

lexical VALUE
  = @category="Value" ("-"?[0-9]+([.][0-9]+?)?); // TODO: Meaning @category?

lexical NAME
  = ([a-zA-Z_$] [a-zA-Z0-9_$]* !>> [a-zA-Z0-9_$]) \ Keyword;
  
lexical STRING
  = ![\"]*;

layout LAYOUTLIST
  = LAYOUT* !>> [\t-\n \r \ : ,];

lexical LAYOUT
  =  [\t-\n \r \ : ,];
  
keyword Keyword
  = "alphabet" | "module" | "register" | "option" | "true" | "false" | "null" ;
  
//////////////////////////////////////////////////////////////////////////////
// API
//////////////////////////////////////////////////////////////////////////////
  
public start[LSP] parseProject(loc file) = 
  parse(#start[LSP], file);