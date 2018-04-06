module tests::parsing::recipe

import parsing::lang::rcp::Syntax;
import parsing::lang::rcp::AST;

public bool runAllTests()
{
	return tryParsing_comment()
	|| tryParsing_singleInstruction()
	|| tryParsing_diceNotation()
	|| tryParsing_basicInstructions()
	|| tryParsing_advancedInstructions()
	|| tryParsing_allInstructions()
	|| tryImploding_comment()
	|| tryImploding_singleInstruction()
	|| tryImploding_diceNotation()
	|| tryImploding_basicInstructions()
	|| tryImploding_advancedInstructions()
	|| tryImploding_allInstructions();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser. //
//////////////////////////////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////////////////////////////
// Tests for AST. //
//////////////////////////////////////////////////////////////////////////////

private test bool tryImploding_comment()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedRecipes/comment.rcp|);
	return true;
}

private test bool tryImploding_singleInstruction()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedRecipes/singleInstruction.rcp|);
	return true;
}

private test bool tryImploding_diceNotation()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedRecipes/diceNotation.rcp|);
	return true;
}

private test bool tryImploding_basicInstructions()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedRecipes/basicInstructions.rcp|);
	return true;
}

private test bool tryImploding_advancedInstructions()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedRecipes/advancedInstructions.rcp|);
	return true;
}

private test bool tryImploding_allInstructions()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedRecipes/allInstructions.rcp|);
	return true;
}