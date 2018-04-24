//////////////////////////////////////////////////////////////////////////////
//
// Parsing tests for .grm files.
// @brief        This file contains unit tests for parsing .grm files to an AST
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         06-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::Grammar

import parsing::Parser;
import tests::parsing::Utility;

public bool runAllTests()
{
	return tryParsingAllOptions()
	&& tryParsingAllRuleSettings()
	&& tryParsingOnlyStart()
	&& tryParsingAllMemberTypes()
	&& tryParsingRuleWithMultipleRightHands()
	&& tryParsingSimpleRule();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser.
//////////////////////////////////////////////////////////////////////////////

private test bool tryParsingAllOptions()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedGrammars/AllOptions.grm|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingAllRuleSettings()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedGrammars/AllRuleSettings.grm|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingOnlyStart()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedGrammars/OnlyStart.grm|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingAllMemberTypes()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedGrammars/AllMemberTypes.grm|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingRuleWithMultipleRightHands()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedGrammars/RuleWithMultipleRightHands.grm|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

// TODO:
private test bool tryParsingRuleWithNestedSymbol()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedGrammars/RuleWithNestedSymbol.grm|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingSimpleRule()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedGrammars/SimpleRule.grm|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}