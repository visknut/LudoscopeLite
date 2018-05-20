//////////////////////////////////////////////////////////////////////////////
//
// Parsing tests for .alp files.
// @brief        This file contains unit tests for parsing .alp files to an AST
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         06-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::Alphabet

import parsing::Parser;
import tests::parsing::Utility;

loc fileLocation = |project://LL/src/tests/correctTestData/isolatedAlphabets/notSet.txt|;
SyntaxTree emptySyntaxTree = syntaxTree([], (), (), (), [], []);

public bool runAllTests()
{
	return tryParsingOnlyColors()
	&& tryParsingColorsAndAbbreviation()
	&& tryParsingCompleteSymbol()
	&& tryParsingMixedSymbols();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser.
//////////////////////////////////////////////////////////////////////////////

private test bool tryParsingOnlyColors()
{
	/* Arrange */
	fileLocation.file = "onlyColors.alp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingColorsAndAbbreviation()
{
	/* Arrange */
	fileLocation.file = "colorsAndAbbreviation.alp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingCompleteSymbol()
{
	/* Arrange */
	fileLocation.file = "completeSymbol.alp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingMixedSymbols()
{
	/* Arrange */
	fileLocation.file = "mixedSymbols.alp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingSymbolWithWildCard()
{
	/* Arrange */
	fileLocation.file = "symbolWithWildCard.alp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}
