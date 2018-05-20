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

loc fileLocation = |project://LL/src/tests/correctTestData/isolatedRecipes/notSet.txt|;
SyntaxTree emptySyntaxTree = syntaxTree([], (), (), (), [], []);

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
	/* Arrange */
	fileLocation.file = "comment.rcp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingSingleInstruction()
{
	/* Arrange */
	fileLocation.file = "singleInstruction.rcp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

// TODO:
private test bool tryParsingDiceNotation()
{
	/* Arrange */
	fileLocation.file = "diceNotation.rcp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingBasicInstructions()
{
	/* Arrange */
	fileLocation.file = "basicInstructions.rcp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingAdvancedInstructions()
{
	/* Arrange */
	fileLocation.file = "advancedInstructions.rcp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingAllInstructions()
{
	/* Arrange */
	fileLocation.file = "allInstructions.rcp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}