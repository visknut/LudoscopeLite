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
	= project: "version" FLOAT version
	Declaration* declarations;
	
syntax Declaration
	=	declaredAlphabet: Alphabet declaredAlphabet
	| declaredModule: 	Module declaredModule
	| declaredOption: 	Option declaredOption
	| declaredRegister:	Register declaredRegister;

syntax Alphabet
	= alphabet: "alphabet"
	"name" String name
	"position" Position position;

syntax Module
  = lspmodule: "module" 
  ("name" String name)?
	("alphabet" String alphabet)?
	("position" Position moduleType)?
	("type" NAME moduleType)?
	("fileName" String fileName)?
	("match" NAME match)?
	("inputs" String* inputs)?
	("maxIterations" INTEGER maxIterations)?
	("filter" String moduleFilter)?
	("grammar" BOOLEAN grammar)?
	("executionType" NAME executionType)?
	("recipe" BOOLEAN recipe)?
	("showMembers" BOOLEAN showMembers)?
	("alwaysStartWithToken" BOOLEAN alwaysStartWithToken)?;
	
syntax Register
	= register: "register" Variable registerContent;
	
syntax Option
	= option: "option" Variable optionContent;

syntax Variable 
  = variableInteger:  NAME name INTEGER integer
  | variableFloat:		NAME name FLOAT float
  | variableString:   NAME name String string
  | variableList:   	NAME name "[" String* "]" listOfVariable
  | variableBoolean:  NAME name BOOLEAN boolean
  | variablePosition: NAME name Position position
  | variableName:  		NAME name NAME variableName
  | variableNull:   	NAME name "null"; 
  
syntax String
  = @category="String" "\"" STRING "\"";
    
syntax Position
  = position: "(" INTEGER x INTEGER y ")";

//////////////////////////////////////////////////////////////////////////////
// Lexer Rules
//////////////////////////////////////////////////////////////////////////////

lexical BOOLEAN
  = @category="Boolean" "true" | "false";

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