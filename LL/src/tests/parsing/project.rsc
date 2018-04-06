module tests::parsing::project

import parsing::lang::lsp::Syntax;
import parsing::lang::lsp::AST;

public bool runAllTests()
{
	return tryParsing_onlyAlphabet()
	|| tryParsing_options()
	|| tryParsing_registers()
	|| tryParsing_singleModule()
	|| tryParsing_multipleModulesWithAlphabet()
	|| tryParsing_completeModule()
	|| tryParsing_complexProject()
	|| tryImploding_onlyAlphabet()
	|| tryImploding_options()
	|| tryImploding_registers()
	|| tryImploding_singleModule()
	|| tryImploding_multipleModulesWithAlphabet()
	|| tryImploding_completeModule()
	|| tryImploding_complexProject();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser. //
//////////////////////////////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////////////////////////////
// Tests for AST. //
//////////////////////////////////////////////////////////////////////////////

private test bool tryImploding_onlyAlphabet()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedProjects/onlyAlphabet.lsp|);
	return true;
}

private test bool tryImploding_options()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedProjects/options.lsp|);
	return true;
}

private test bool tryImploding_registers()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedProjects/registers.lsp|);
	return true;
}

private test bool tryImploding_singleModule()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedProjects/singleModule.lsp|);
	return true;
}

private test bool tryImploding_multipleModulesWithAlphabet()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedProjects/multipleModulesWithAlphabet.lsp|);
	return true;
}

private test bool tryImploding_completeModule()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedProjects/completeModule.lsp|);
	return true;
}

private test bool tryImploding_complexProject()
{
	parseToAST(|project://LL/src/tests/testData/IsolatedProjects/complexProject.lsp|);
	return true;
}