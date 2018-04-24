//////////////////////////////////////////////////////////////////////////////
//
// Parsing tests for .rcp files.
// @brief        This file contains unit tests for parsing .rcp files to an AST
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         06-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::Recipe

import parsing::Parser;
import tests::parsing::Utility;

public bool runAllTests()
{
	return tryParsingComment()
	&& tryParsingSingleInstruction()
	&& tryParsingBasicInstructions()
	&& tryParsingAdvancedInstructions()
	&& tryParsingAllInstructions();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser.
//////////////////////////////////////////////////////////////////////////////

private test bool tryParsingComment()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedRecipes/Comment.rcp|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingSingleInstruction()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedRecipes/SingleInstruction.rcp|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

// TODO:
private test bool tryParsingDiceNotation()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedRecipes/DiceNotation.rcp|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingBasicInstructions()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedRecipes/BasicInstructions.rcp|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingAdvancedInstructions()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedRecipes/AdvancedInstructions.rcp|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingAllInstructions()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedRecipes/AllInstructions.rcp|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}