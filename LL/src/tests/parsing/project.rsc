module tests::parsing::project

import parsing::lang::lsp::Syntax;

public test bool runAllTests()
{
	return tryParsing_onlyAlphabet()
	|| tryParsing_options()
	|| tryParsing_registers()
	|| tryParsing_singleModule()
	|| tryParsing_multipleModulesWithAlphabet()
	|| tryParsing_completeModule()
	|| tryParsing_complexProject();
}

private test bool tryParsing_onlyAlphabet()
{
	lsp_parse(|project://LL/src/tests/testData/IsolatedProjects/onlyAlphabet.lsp|);
	return true;
}

private test bool tryParsing_options()
{
	lsp_parse(|project://LL/src/tests/testData/IsolatedProjects/options.lsp|);
	return true;
}

private test bool tryParsing_registers()
{
	lsp_parse(|project://LL/src/tests/testData/IsolatedProjects/registers.lsp|);
	return true;
}

private test bool tryParsing_singleModule()
{
	lsp_parse(|project://LL/src/tests/testData/IsolatedProjects/singleModule.lsp|);
	return true;
}

private test bool tryParsing_multipleModulesWithAlphabet()
{
	lsp_parse(|project://LL/src/tests/testData/IsolatedProjects/multipleModulesWithAlphabet.lsp|);
	return true;
}

private test bool tryParsing_completeModule()
{
	lsp_parse(|project://LL/src/tests/testData/IsolatedProjects/completeModule.lsp|);
	return true;
}

private test bool tryParsing_complexProject()
{
	lsp_parse(|project://LL/src/tests/testData/IsolatedProjects/complexProject.lsp|);
	return true;
}