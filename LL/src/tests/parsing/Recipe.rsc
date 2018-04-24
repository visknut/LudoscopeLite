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
SyntaxTree emptySyntaxTree = syntaxTree([], (), (), (), []);

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
	fileLocation.file = "Comment.rcp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingSingleInstruction()
{
	/* Arrange */
	fileLocation.file = "SingleInstruction.rcp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

// TODO:
private test bool tryParsingDiceNotation()
{
	/* Arrange */
	fileLocation.file = "DiceNotation.rcp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingBasicInstructions()
{
	/* Arrange */
	fileLocation.file = "BasicInstructions.rcp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingAdvancedInstructions()
{
	/* Arrange */
	fileLocation.file = "AdvancedInstructions.rcp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingAllInstructions()
{
	/* Arrange */
	fileLocation.file = "AllInstructions.rcp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}