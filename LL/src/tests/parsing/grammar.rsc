module tests::parsing::grammar

import parsing::lang::grm::Syntax;
import parsing::lang::grm::AST;

public bool runAllTests()
{
	return tryParsing_allOptions()
	|| tryParsing_allRuleSettings()
	|| tryParsing_onlyStart()
	|| tryParsing_ruleWithExpression()
	|| tryParsing_ruleWithMultipleRightHands()
	|| tryParsing_ruleWithNestedSymbol()
	|| tryParsing_simpleRule()
	|| tryImploding_allOptions()
	|| tryImploding_allRuleSettings()
	|| tryImploding_onlyStart()
	|| tryImploding_ruleWithExpression()
	|| tryImploding_ruleWithMultipleRightHands()
	|| tryImploding_ruleWithNestedSymbol()
	|| tryImploding_simpleRule();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser. //
//////////////////////////////////////////////////////////////////////////////

private test bool tryParsing_allOptions()
{
	grm_parse(|project://LL/src/tests/testData/IsolatedGrammars/allOptions.grm|);
	return true;
}

private test bool tryParsing_allRuleSettings()
{
	grm_parse(|project://LL/src/tests/testData/IsolatedGrammars/allRuleSettings.grm|);
	return true;
}

private test bool tryParsing_onlyStart()
{
	grm_parse(|project://LL/src/tests/testData/IsolatedGrammars/onlyStart.grm|);
	return true;
}

private test bool tryParsing_ruleWithExpression()
{
	grm_parse(|project://LL/src/tests/testData/IsolatedGrammars/ruleWithExpression.grm|);
	return true;
}

private test bool tryParsing_ruleWithMultipleRightHands()
{
	grm_parse(|project://LL/src/tests/testData/IsolatedGrammars/ruleWithMultipleRightHands.grm|);
	return true;
}

private test bool tryParsing_ruleWithNestedSymbol()
{
	grm_parse(|project://LL/src/tests/testData/IsolatedGrammars/ruleWithNestedSymbol.grm|);
	return true;
}

private test bool tryParsing_simpleRule()
{
	grm_parse(|project://LL/src/tests/testData/IsolatedGrammars/simpleRule.grm|);
	return true;
}

//////////////////////////////////////////////////////////////////////////////
// Tests for AST. //
//////////////////////////////////////////////////////////////////////////////

private test bool tryImploding_allOptions()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedGrammars/allOptions.grm|);
	return true;
}

private test bool tryImploding_allRuleSettings()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedGrammars/allRuleSettings.grm|);
	return true;
}

private test bool tryImploding_onlyStart()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedGrammars/onlyStart.grm|);
	return true;
}

private test bool tryImploding_ruleWithExpression()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedGrammars/ruleWithExpression.grm|);
	return true;
}

private test bool tryImploding_ruleWithMultipleRightHands()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedGrammars/ruleWithMultipleRightHands.grm|);
	return true;
}

private test bool tryImploding_ruleWithNestedSymbol()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedGrammars/ruleWithNestedSymbol.grm|);
	return true;
}

private test bool tryImploding_simpleRule()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedGrammars/simpleRule.grm|);
	return true;
}