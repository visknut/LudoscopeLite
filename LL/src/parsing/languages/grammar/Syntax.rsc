//////////////////////////////////////////////////////////////////////////////
//
// Syntax for .grm files.
// @brief        This files contains the syntax needed for parsing .grm files.
//							 .grm files contain the grammar of a module.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         03-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::languages::grammar::Syntax

import ParseTree;

//////////////////////////////////////////////////////////////////////////////
// Parser Rules
//////////////////////////////////////////////////////////////////////////////  

start syntax Grammar
	= grammar: "version" ":" FLOAT StartInput Rule* Options;
	
syntax StartInput
  = startInput: "start" ":" Expression;
  
syntax Rule
	= rule: "rule" ":" NAME ("(" RuleSettings+ ")")? "=" 
		LeftHandExpression "\>" RightHandExpression+;

syntax Options
	= options: ("checkCollisions" ":" BOOLEAN)?
		("stayWithinBounds" ":" BOOLEAN)?
		("trackNonTerminals" ":" BOOLEAN)?
		("findOnlyOneOption" ":" BOOLEAN)?;
		
syntax Expression
	= expression: MapType Symbol+;
	
syntax RightHandExpression
	= rightHandExpression: "{" INTEGER "=" Expression "}";
	
syntax LeftHandExpression
	= leftHandExpression: MapType LeftHandSymbol+;
	
syntax Symbol
	= symbol: INTEGER ":" NAME ("(" MemberStatement+ ")")?;
	
syntax LeftHandSymbol
	= leftHandSymbol: INTEGER ":" NAME ("(" MemberExpression+ ")")?;
	
syntax MemberStatement
	= memberStatement: NAME "=" Value;

// TODO: Implement expressions.
syntax MemberExpression
	= memberExpression: NAME "==" Value;

syntax MapType
	= tileMap: "TILEMAP" INTEGER INTEGER
	| string: "STRING"
	| graph: "GRAPH"
	| shape: "SHAPE";

syntax RuleSettings
	= ruleWidth: "width" "=" INTEGER
	|	ruleHeight: "height" "=" INTEGER
	| ruleTopology: "gt" "=" INTEGER;

syntax Value
	= integerValue: INTEGER 
	| floatValue: FLOAT 
	| stringValue: String 
	| booleanValue: BOOLEAN
	| colorValue:	COLORCODE
	| vectorValue: Vector
	| listValue: "[" Value* "]";

syntax String
  = "\"" STRING "\"";
  
syntax Vector
	= vector2d: "(" INTEGER INTEGER ")"
	| vector3d: "(" INTEGER INTEGER INTEGER ")"
	| vector4d: "(" INTEGER INTEGER INTEGER INTEGER ")";

//////////////////////////////////////////////////////////////////////////////
// Lexer Rules
//////////////////////////////////////////////////////////////////////////////

lexical BOOLEAN
	= "true" | "false";

lexical NAME
  = ([a-zA-Z_$.] [a-zA-Z0-9_$.]* !>> [a-zA-Z0-9_$.]) \ Keyword;

lexical COLORCODE
	= "#" [0-9A-Z]*;
 
lexical INTEGER
  = ("-"?[0-9]+);
  
lexical FLOAT
  = ("-"?[0-9]+([.][0-9]+?)?"f");
    
lexical STRING
  = ![\"]*;

//////////////////////////////////////////////////////////////////////////////
// Layout
//////////////////////////////////////////////////////////////////////////////  

layout LAYOUTLIST
  = LAYOUT* !>> [\t-\n \r \ , |];

lexical LAYOUT
  =  [\t-\n \r \ , | { } ( ) =];
  
keyword Keyword
  = "version"
  | "start"
  | "rule"
  | "TILEMAP"
  | "width"
  | "height"
  | "gt"
  |	"true"
  |	"false"
  | "checkCollisions"
	| "stayWithinBounds"
	| "trackNonTerminals"
	| "findOnlyOneOption"
	| "TILEMAP"
  | "STRING"
  | "GRAPH"
  | "SHAPE";
  
//////////////////////////////////////////////////////////////////////////////
// API
//////////////////////////////////////////////////////////////////////////////
  
public start[Grammar] parseGrammar(loc file) = 
  parse(#start[Grammar], file);