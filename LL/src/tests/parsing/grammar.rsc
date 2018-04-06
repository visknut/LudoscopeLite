module tests::parsing::grammar

import parsing::lang::grm::Syntax;

public test bool runAllTests()
{
	return tryParsing_allOptions()
	|| tryParsing_allRuleSettings()
	|| tryParsingcolors_onlyStart()
	|| tryParsing_ruleWithExpression()
	|| tryParsing_ruleWithMultipleRightHands()
	|| tryParsing_ruleWithNestedSymbol()
	|| tryParsing_simpleRule();
}

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

private test bool tryParsingcolors_onlyStart()
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