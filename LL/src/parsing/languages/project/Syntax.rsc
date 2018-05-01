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
// Parser Rules
////////////////////////////////////////////////////////////////////////////// 

start syntax Project
	= project: "version" FLOAT 
	Declaration*;
	
syntax Declaration
	=	declaredAlphabet: Alphabet 
	| declaredModule: 	Module 
	| declaredOption: 	Option 
	| declaredRegister:	Register;

syntax Alphabet
	= alphabet: "alphabet"
	"name:" String
	"position:" Position;

syntax Module
  = lspmodule: "module" 
  ("name" String)?
	("alphabet" String)?
	("position" Position)?
	("type" NAME)?
	("fileName" String)?
	("match" NAME)?
	("inputs" String*)?
	("maxIterations" INTEGER)?
	("filter" String)?
	("grammar" BOOLEAN)?
	("executionType" NAME)?
	("recipe" BOOLEAN)?
	("showMembers" BOOLEAN)?
	("alwaysStartWithToken" BOOLEAN)?;
	
syntax Register
	= register: "register" Variable;
	
syntax Option
	= option: "option" Variable;

syntax Variable 
  = variableInteger:  NAME INTEGER
  | variableFloat:		NAME FLOAT 
  | variableString:   NAME String 
  | variableList:   	NAME "[" String* "]"
  | variableBoolean:  NAME BOOLEAN 
  | variablePosition: NAME Position 
  | variableName:  		NAME NAME 
  | variableNull:   	NAME "null"; 
  
syntax String
  = @category="String" "\"" STRING "\"";
    
syntax Position
  = position: "(" INTEGER INTEGER ")";

//////////////////////////////////////////////////////////////////////////////
// Lexer Rules
//////////////////////////////////////////////////////////////////////////////

lexical BOOLEAN
  = "true" | "false";

lexical FLOAT
	= INTEGER ([.][0-9]+?)? "f";
  
lexical INTEGER
  = ("-"?[0-9]+);

lexical NAME
  = @category="Name" ([a-zA-Z_$] [a-zA-Z0-9_$]* !>> [a-zA-Z0-9_$]) \ Keyword;
  
lexical STRING
  = ![\"]*;

//////////////////////////////////////////////////////////////////////////////
// Layout
//////////////////////////////////////////////////////////////////////////////

layout LAYOUTLIST
  = LAYOUT* !>> [\t-\n \r \ : ,];

lexical LAYOUT
  =  [\t-\n \r \ : ,];
  
keyword Keyword
  = "version"
  | "alphabet"
	| "module" 
	| "register" 
	| "option" 
	| "true" 
	| "false" 
	| "null" 
	| "name"
	| "alphabet"
	| "position"
	| "type"
	| "fileName"
	| "match"
	| "inputs"
	| "maxIterations"
	| "filter"
	| "grammar"
	| "executionType"
	| "recipe"
	| "showMembers"
	| "alwaysStartWithToken";
  
//////////////////////////////////////////////////////////////////////////////
// API
//////////////////////////////////////////////////////////////////////////////
  
public start[Project] parseProject(loc file) = 
  parse(#start[Project], file);
  
public start[Project] parseProject(str input, loc location) 
{ 
	return parse(#start[Project], input, location); 
}