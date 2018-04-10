//////////////////////////////////////////////////////////////////////////////
//
// Parsing tests for .grm files.
// @brief        This file contains unit tests for parsing .grm files to an AST
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         06-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::Grammar

import IO;
import ParseTree;
import parsing::languages::grammar::AST;
import parsing::languages::grammar::Syntax;

public bool runAllTests()
{
	return tryParsingAllOptions()
	&& tryParsingAllRuleSettings()
	&& tryParsingOnlyStart()
	&& tryParsingAllMemberTypes()
	&& tryParsingRuleWithMultipleRightHands()
	&& tryParsingRuleWithNestedSymbol()
	&& tryParsingSimpleRule();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser.
//////////////////////////////////////////////////////////////////////////////

private bool grammarParsingTest(loc fileToParse)
{
	Tree tree;
	/* First try parsing to a parse tree. */
	try {
		tree = parseGrammar(fileToParse);
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
		implodeGrammar(tree);
	}
	catch IllegalArgument(value v, str message):
	{
		println("Error: could not implode the parse tree to an AST");
		return false;
	}
	return true;
}

private test bool tryParsingAllOptions()
{
	return grammarParsingTest(|project://LL/src/tests/testData/isolatedGrammars/AllOptions.grm|);
}

private test bool tryParsingAllRuleSettings()
{
	return grammarParsingTest(|project://LL/src/tests/testData/isolatedGrammars/AllRuleSettings.grm|);
}

private test bool tryParsingOnlyStart()
{
	return grammarParsingTest(|project://LL/src/tests/testData/isolatedGrammars/OnlyStart.grm|);
}

private test bool tryParsingAllMemberTypes()
{
	return grammarParsingTest(|project://LL/src/tests/testData/isolatedGrammars/AllMemberTypes.grm|);
}

private test bool tryParsingRuleWithMultipleRightHands()
{
	return grammarParsingTest(|project://LL/src/tests/testData/isolatedGrammars/RuleWithMultipleRightHands.grm|);
}

private test bool tryParsingRuleWithNestedSymbol()
{
	return grammarParsingTest(|project://LL/src/tests/testData/isolatedGrammars/RuleWithNestedSymbol.grm|);
}

private test bool tryParsingSimpleRule()
{
	return grammarParsingTest(|project://LL/src/tests/testData/isolatedGrammars/SimpleRule.grm|);
}