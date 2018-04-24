//////////////////////////////////////////////////////////////////////////////
//
// The AST used for parsing .grm files.
// @brief        This file contains the data structure needed for imploding
//							 a parsed .grm tree.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         03-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::languages::grammar::AST

import parsing::languages::grammar::Syntax;
import ParseTree;

//////////////////////////////////////////////////////////////////////////////
// APIs
//////////////////////////////////////////////////////////////////////////////

public parsing::languages::grammar::AST::Grammar implodeGrammar(Tree tree)
  = implode(#parsing::languages::grammar::AST::Grammar, tree);
  
public parsing::languages::grammar::AST::Grammar parseGrammarToAST(loc location)
	= implodeGrammar(parseGrammar(location));

//////////////////////////////////////////////////////////////////////////////
// AST
//////////////////////////////////////////////////////////////////////////////

anno loc MapType@location;

data Grammar
	= grammar(str version, 
	StartInput startInput,
	list[Rule] rules,
	Options options);

data StartInput
	= startInput(Expression expression);

data Rule
	= rule(str name, list[RuleSetting] settings, LeftHandExpression leftHand, 
		list[RightHandExpression] rightHands);
	
data Expression
	= expression(MapType mapType, list[Symbol] symbols);
	
data LeftHandExpression
	= leftHandExpression(MapType mapType, list[LeftHandSymbol] symbols);
	
data RightHandExpression
	= rightHandExpression(int id, Expression expression);
	
data MapType
	= tileMap(int width, int height)
	| string()
	| graph()
	| shape();
	
data Symbol
	= symbol(int id, str name, list[MemberStatement] members);
	
data LeftHandSymbol
	= leftHandSymbol(int id, str name, list[MemberExpression] members);
	
data Options
	= options(str checkCollisions, 
		str stayWithinBounds, 
		str trackNonTerminals, 
		str findOnlyOneOption);
		
data RuleSetting
	= ruleWidth(int width)
	| ruleHeight(int height)
	| ruleReflections(int reflections);
		
data MemberStatement
	= memberStatement(str identifier, Value memberValue);
	
data MemberExpression
	= memberExpression(str identifier, Value memberValue);
	
data Value
	= integerValue(str integer)
	| floatValue(str float)
	| stringValue(str string)
	| booleanValue(str boolean)
	| colorValue(str color)
	| vectorValue(Vector vector)
	| listValue(list[Value] memberList);
	
data Vector
	= vector2d(int x, int y)
	| vector3d(int x, int y, int z)
	| vecotr4d(int x, int y, int z, int a);