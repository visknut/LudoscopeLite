module tests::parsing::alphabet

import parsing::lang::alp::Syntax;

public test bool runAllTests()
{
	return tryParsing_onlyColors()
	|| tryParsing_noShape()
	|| tryParsing_colorsAndAbbreviation()
	|| tryParsing_completeSymbol()
	|| tryParsing_mixedSymbols();
}

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