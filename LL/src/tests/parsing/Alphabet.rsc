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

public bool runAllTests()
{
	return tryParsingOnlyColors()
	&& tryParsingColorsAndAbbreviation()
	&& tryParsingCompleteSymbol()
	&& tryParsingMixedSymbols();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for pasrser.
//////////////////////////////////////////////////////////////////////////////

private test bool tryParsingOnlyColors()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedAlphabets/OnlyColors.alp|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingColorsAndAbbreviation()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedAlphabets/ColorsAndAbbreviation.alp|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingCompleteSymbol()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedAlphabets/CompleteSymbol.alp|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingMixedSymbols()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedAlphabets/MixedSymbols.alp|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingSymbolWithWildCard()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedAlphabets/SymbolWithWildCard.alp|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}
