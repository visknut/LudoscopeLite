module lang::lsp::Syntax
import ParseTree;

start syntax LSP
	= lsp: Alphabet* Module* ("register" Variable)* ("option" Variable)*;

syntax Alphabet
	= alphabet: "alphabet" Variable*;

syntax Module
  = lspmodule: "module" Variable*;

syntax Variable
	= varInt: 	NAME VALUE
	| varStr:	NAME String
	| varList: 	NAME "[" String* "]" // List of strings without brackets.
	| varBool: 	NAME BOOLEAN
	| varPos:	NAME Position
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
  
public start[LSP] lsp_parse(loc file) = 
  parse(#start[LSP], file);
  
public start[LSP] lsp_parse_test() = 
   lsp_parse(|project://LL/src/lang/testdate/completeProject.lsp|);