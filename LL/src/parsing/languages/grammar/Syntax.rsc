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
	= grammar: 
			"version" ":" FLOAT version 
			StartInput startInput
			Rule* rules
			Options options;
	
syntax StartInput
  = startInput: "start" ":" Expression expression;
  
syntax Rule
	= rule: 
			"rule" ":" NAME name
			("(" RuleSettings+ settings ")")? "=" 
			LeftHandExpression leftHand"\>" 
			RightHandExpression+ rightHands;

syntax Options
	= options: 
			("checkCollisions" ":" BOOLEAN checkCollisions)?
			("stayWithinBounds" ":" BOOLEAN stayWithinBounds)?
			("trackNonTerminals" ":" BOOLEAN trackNonTerminals)?
			("findOnlyOneOption" ":" BOOLEAN findOnlyOneOption)?;
		
syntax Expression
	= expression: 
			MapType mapType 
			Symbol+ symbols;
	
syntax RightHandExpression
	= rightHandExpression: 
			"{" INTEGER id "=" 
			Expression expression "}";

syntax LeftHandExpression
	= leftHandExpression: 
			MapType mapType
			MatchingSymbol+ symbols;

syntax Symbol
	= symbol:
			INTEGER id ":" 
			NAME name
			("(" MemberStatement+ members ")")?;
	
syntax MatchingSymbol
	= matchingSymbol: 
			INTEGER id ":" 
			NAME name
			("(" MemberExpression+ members ")")?;
	
syntax MemberStatement
	= memberStatement: 
			NAME identifier "=" 
			Value memberValue;

// TODO: Implement expressions.
syntax MemberExpression
	= memberExpression: NAME "==" Value;

syntax MapType
	= tileMap: 
			"TILEMAP" INTEGER width
			INTEGER height
	| string: "STRING"
	| graph: "GRAPH"
	| shape: "SHAPE";

syntax RuleSettings
	= ruleWidth: "width" "=" INTEGER width
	|	ruleHeight: "height" "=" INTEGER height
	| ruleReflections: "gt" "=" INTEGER reflections;

syntax Value
	= integerValue: INTEGER integer
	| floatValue: FLOAT float
	| stringValue: String string
	| booleanValue: BOOLEAN boolean
	| colorValue:	COLORCODE color
	| vectorValue: Vector vector
	| listValue: "[" Value* memberList "]";

syntax String
  = @category="String" "\"" STRING "\"";
  
syntax Vector
	= vector2d: 
			"(" INTEGER x
			INTEGER y ")"
	| vector3d: 
			"(" INTEGER x
			INTEGER y
			INTEGER z ")"
	| vector4d: 
			"(" INTEGER x
			INTEGER y
			INTEGER z
			INTEGER a ")";

//////////////////////////////////////////////////////////////////////////////
// Lexer Rules
//////////////////////////////////////////////////////////////////////////////

lexical BOOLEAN
	= @category="Boolean" "true" | "false";

lexical NAME
  = @category="Name" ([a-zA-Z_$.] [a-zA-Z0-9_$.]* !>> [a-zA-Z0-9_$.]) \ Keyword;

lexical COLORCODE
	= @category="ColorCode" "#" [0-9A-Z]*;
 
lexical INTEGER
  = ("-"?[0-9]+);
  
lexical FLOAT
  = INTEGER ([.][0-9]+?)? "f";
    
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
  
public start[Grammar] parseGrammar(str input, loc location) 
{ 
	return parse(#start[Grammar], input, location); 
}