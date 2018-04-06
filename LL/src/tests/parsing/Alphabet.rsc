//////////////////////////////////////////////////////////////////////////////
//
// Parsing tests for .alp files.
// @brief        This file contains unit tests for parsing .alp files to an AST
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         06-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::Alphabet

import parsing::languages::alphabet::Syntax;
import parsing::languages::alphabet::AST;

public bool runAllTests()
{
	return tryParsingOnlyColors()
	&& tryParsingNoShape()
	&& tryParsingColorsAndAbbreviation()
	&& tryParsingCompleteSymbol()
	&& tryParsingMixedSymbols()
	&& tryImplodingOnlyColors()
	&& tryImplodingNoShape()
	&& tryImplodingColorsAndAbbreviation()
	&& tryImplodingCompleteSymbol()
	&& tryImplodingMixedSymbols();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for pasrser.
//////////////////////////////////////////////////////////////////////////////

private test bool tryParsingOnlyColors()
{
	parseAlphabet(|project://LL/src/tests/testData/isolatedAlphabets/OnlyColors.alp|);
	return true;
}

private test bool tryParsingNoShape()
{
	parseAlphabet(|project://LL/src/tests/testData/isolatedAlphabets/NoShape.alp|);
	return true;
}

private test bool tryParsingColorsAndAbbreviation()
{
	parseAlphabet(|project://LL/src/tests/testData/isolatedAlphabets/ColorsAndAbbreviation.alp|);
	return true;
}

private test bool tryParsingCompleteSymbol()
{
	parseAlphabet(|project://LL/src/tests/testData/isolatedAlphabets/CompleteSymbol.alp|);
	return true;
}

private test bool tryParsingMixedSymbols()
{
	parseAlphabet(|project://LL/src/tests/testData/isolatedAlphabets/MixedSymbols.alp|);
	return true;
}

//////////////////////////////////////////////////////////////////////////////
// Tests for AST.
//////////////////////////////////////////////////////////////////////////////

private test bool tryImplodingOnlyColors()
{
	parseAlphabetToAST(|project://LL/src/tests/testData/isolatedAlphabets/OnlyColors.alp|);
	return true;
}

private test bool tryImplodingNoShape()
{
	parseAlphabetToAST(|project://LL/src/tests/testData/isolatedAlphabets/NoShape.alp|);
	return true;
}

private test bool tryImplodingColorsAndAbbreviation()
{
	parseAlphabetToAST(|project://LL/src/tests/testData/isolatedAlphabets/ColorsAndAbbreviation.alp|);
	return true;
}

private test bool tryImplodingCompleteSymbol()
{
	parseAlphabetToAST(|project://LL/src/tests/testData/isolatedAlphabets/CompleteSymbol.alp|);
	return true;
}

private test bool tryImplodingMixedSymbols()
{
	parseAlphabetToAST(|project://LL/src/tests/testData/isolatedAlphabets/MixedSymbols.alp|);
	return true;
}