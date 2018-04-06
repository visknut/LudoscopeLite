//////////////////////////////////////////////////////////////////////////////
//
// Parsing tests for .grm files.
// @brief        This file contains unit tests for parsing .grm files to an AST
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         06-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::Grammar

import parsing::languages::grammar::Syntax;
import parsing::languages::grammar::AST;

public bool runAllTests()
{
	return tryParsingAllOptions()
	&& tryParsingAllRuleSettings()
	&& tryParsingOnlyStart()
	&& tryParsingRuleWithExpression()
	&& tryParsingRuleWithMultipleRightHands()
	&& tryParsingRuleWithNestedSymbol()
	&& tryParsingSimpleRule()
	&& tryImplodingAllOptions()
	&& tryImplodingAllRuleSettings()
	&& tryImplodingOnlyStart()
	&& tryImplodingRuleWithExpression()
	&& tryImplodingRuleWithMultipleRightHands()
	&& tryImplodingRuleWithNestedSymbol()
	&& tryImplodingSimpleRule();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser.
//////////////////////////////////////////////////////////////////////////////

private test bool tryParsingAllOptions()
{
	parseGrammar(|project://LL/src/tests/testData/isolatedGrammars/AllOptions.grm|);
	return true;
}

private test bool tryParsingAllRuleSettings()
{
	parseGrammar(|project://LL/src/tests/testData/isolatedGrammars/AllRuleSettings.grm|);
	return true;
}

private test bool tryParsingOnlyStart()
{
	parseGrammar(|project://LL/src/tests/testData/isolatedGrammars/OnlyStart.grm|);
	return true;
}

private test bool tryParsingRuleWithExpression()
{
	parseGrammar(|project://LL/src/tests/testData/isolatedGrammars/RuleWithExpression.grm|);
	return true;
}

private test bool tryParsingRuleWithMultipleRightHands()
{
	parseGrammar(|project://LL/src/tests/testData/isolatedGrammars/RuleWithMultipleRightHands.grm|);
	return true;
}

private test bool tryParsingRuleWithNestedSymbol()
{
	parseGrammar(|project://LL/src/tests/testData/isolatedGrammars/RuleWithNestedSymbol.grm|);
	return true;
}

private test bool tryParsingSimpleRule()
{
	parseGrammar(|project://LL/src/tests/testData/isolatedGrammars/SimpleRule.grm|);
	return true;
}

//////////////////////////////////////////////////////////////////////////////
// Tests for AST.
//////////////////////////////////////////////////////////////////////////////

private test bool tryImplodingAllOptions()
{
	parseGrammarToAST(|project://LL/src/tests/testData/isolatedGrammars/AllOptions.grm|);
	return true;
}

private test bool tryImplodingAllRuleSettings()
{
	parseGrammarToAST(|project://LL/src/tests/testData/isolatedGrammars/allRuleSettings.grm|);
	return true;
}

private test bool tryImplodingOnlyStart()
{
	parseGrammarToAST(|project://LL/src/tests/testData/isolatedGrammars/OnlyStart.grm|);
	return true;
}

private test bool tryImplodingRuleWithExpression()
{
	parseGrammarToAST(|project://LL/src/tests/testData/isolatedGrammars/RuleWithExpression.grm|);
	return true;
}

private test bool tryImplodingRuleWithMultipleRightHands()
{
	parseGrammarToAST(|project://LL/src/tests/testData/isolatedGrammars/RuleWithMultipleRightHands.grm|);
	return true;
}

private test bool tryImplodingRuleWithNestedSymbol()
{
	parseGrammarToAST(|project://LL/src/tests/testData/isolatedGrammars/RuleWithNestedSymbol.grm|);
	return true;
}

private test bool tryImplodingSimpleRule()
{
	parseGrammarToAST(|project://LL/src/tests/testData/isolatedGrammars/SimpleRule.grm|);
	return true;
}