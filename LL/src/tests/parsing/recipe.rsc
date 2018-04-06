module tests::parsing::recipe

import parsing::lang::rcp::Syntax;

public test bool runAllTests()
{
	return tryParsing_comment()
	|| tryParsing_singleInstruction()
	|| tryParsing_diceNotation()
	|| tryParsing_basicInstructions()
	|| tryParsing_advancedInstructions()
	|| tryParsing_allInstructions();
}

private test bool tryParsing_comment()
{
	rcp_parse(|project://LL/src/tests/testData/IsolatedRecipes/comment.rcp|);
	return true;
}

private test bool tryParsing_singleInstruction()
{
	rcp_parse(|project://LL/src/tests/testData/IsolatedRecipes/singleInstruction.rcp|);
	return true;
}

private test bool tryParsing_diceNotation()
{
	rcp_parse(|project://LL/src/tests/testData/IsolatedRecipes/diceNotation.rcp|);
	return true;
}

private test bool tryParsing_basicInstructions()
{
	rcp_parse(|project://LL/src/tests/testData/IsolatedRecipes/basicInstructions.rcp|);
	return true;
}

private test bool tryParsing_advancedInstructions()
{
	rcp_parse(|project://LL/src/tests/testData/IsolatedRecipes/advancedInstructions.rcp|);
	return true;
}

private test bool tryParsing_allInstructions()
{
	rcp_parse(|project://LL/src/tests/testData/IsolatedRecipes/allInstructions.rcp|);
	return true;
}