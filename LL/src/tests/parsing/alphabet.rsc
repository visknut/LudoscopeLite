module tests::parsing::alphabet

import parsing::lang::alp::Syntax;
import parsing::lang::alp::AST;

public bool runAllTests()
{
	return tryParsing_onlyColors()
	|| tryParsing_noShape()
	|| tryParsing_colorsAndAbbreviation()
	|| tryParsing_completeSymbol()
	|| tryParsing_mixedSymbols()
	|| tryImploding_onlyColors()
	|| tryImploding_noShape()
	|| tryImploding_colorsAndAbbreviation()
	|| tryImploding_completeSymbol()
	|| tryImploding_mixedSymbols();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for pasrser. //
//////////////////////////////////////////////////////////////////////////////

private test bool tryParsing_onlyColors()
{
	alp_parse(|project://LL/src/tests/testData/IsolatedAlphabets/onlyColors.alp|);
	return true;
}

private test bool tryParsing_noShape()
{
	alp_parse(|project://LL/src/tests/testData/IsolatedAlphabets/noShape.alp|);
	return true;
}

private test bool tryParsing_colorsAndAbbreviation()
{
	alp_parse(|project://LL/src/tests/testData/IsolatedAlphabets/colorsAndAbbreviation.alp|);
	return true;
}

private test bool tryParsing_completeSymbol()
{
	alp_parse(|project://LL/src/tests/testData/IsolatedAlphabets/completeSymbol.alp|);
	return true;
}

private test bool tryParsing_mixedSymbols()
{
	alp_parse(|project://LL/src/tests/testData/IsolatedAlphabets/mixedSymbols.alp|);
	return true;
}

//////////////////////////////////////////////////////////////////////////////
// Tests for AST. //
//////////////////////////////////////////////////////////////////////////////

private test bool tryImploding_onlyColors()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedAlphabets/onlyColors.alp|);
	return true;
}

private test bool tryImploding_noShape()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedAlphabets/noShape.alp|);
	return true;
}

private test bool tryImploding_colorsAndAbbreviation()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedAlphabets/colorsAndAbbreviation.alp|);
	return true;
}

private test bool tryImploding_completeSymbol()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedAlphabets/completeSymbol.alp|);
	return true;
}

private test bool tryImploding_mixedSymbols()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedAlphabets/mixedSymbols.alp|);
	return true;
}