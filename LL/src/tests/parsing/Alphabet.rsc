//////////////////////////////////////////////////////////////////////////////
//
// Parsing tests for .alp files.
// @brief        This file contains unit tests for parsing .alp files to an AST
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         06-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::Alphabet

import IO;
import ParseTree;
import parsing::languages::alphabet::Syntax;
import parsing::languages::alphabet::AST;

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

private bool alphabetParsingTest(loc fileToParse)
{
	Tree tree;
	/* First try parsing to a parse tree. */
	try {
		tree = parseAlphabet(fileToParse);
	}
	catch ParseError(loc errorLocation):
	{
		print("Error: could not parse the file. \n@");
		println(errorLocation);
		return false;
	}
	catch Ambiguity(loc errorLocation, str usedSyntax, str parsedText):
	{
		print("Error: ambiguity found during parsing. \n@");
		println(errorLocation);
		return false;
	}
	/* Then try to implode the parse tree to an AST. */
	try {
		implodeAlphabet(tree);
	}
	catch IllegalArgument(value v, str message):
	{
		println("Error: could not implode the parse tree to an AST");
		return false;
	}
	return true;
}

private test bool tryParsingOnlyColors()
{
	return alphabetParsingTest(|project://LL/src/tests/testData/isolatedAlphabets/OnlyColors.alp|);
}

private test bool tryParsingColorsAndAbbreviation()
{
	return alphabetParsingTest(|project://LL/src/tests/testData/isolatedAlphabets/ColorsAndAbbreviation.alp|);
}

private test bool tryParsingCompleteSymbol()
{
	return alphabetParsingTest(|project://LL/src/tests/testData/isolatedAlphabets/CompleteSymbol.alp|);
}

private test bool tryParsingMixedSymbols()
{
	return alphabetParsingTest(|project://LL/src/tests/testData/isolatedAlphabets/MixedSymbols.alp|);
}
