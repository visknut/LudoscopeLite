//////////////////////////////////////////////////////////////////////////////
//
// Parsing tests for .lsp files.
// @brief        This file contains unit tests for parsing .lsp files to an AST
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         06-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::Project

import parsing::languages::project::Syntax;
import parsing::languages::project::AST;

public bool runAllTests()
{
	return tryParsingOnlyAlphabet()
	&& tryParsingOptions()
	&& tryParsingRegisters()
	&& tryParsingSingleModule()
	&& tryParsingMultipleModulesWithAlphabet()
	&& tryParsingCompleteModule()
	&& tryParsingComplexProject()
	&& tryImplodingOnlyAlphabet()
	&& tryImplodingOptions()
	&& tryImplodingRegisters()
	&& tryImplodingSingleModule()
	&& tryImplodingMultipleModulesWithAlphabet()
	&& tryImplodingCompleteModule()
	&& tryImplodingComplexProject();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser.
//////////////////////////////////////////////////////////////////////////////

private test bool tryParsingOnlyAlphabet()
{
	parseProject(|project://LL/src/tests/testData/isolatedProjects/OnlyAlphabet.lsp|);
	return true;
}

private test bool tryParsingOptions()
{
	parseProject(|project://LL/src/tests/testData/isolatedProjects/Options.lsp|);
	return true;
}

private test bool tryParsingRegisters()
{
	parseProject(|project://LL/src/tests/testData/isolatedProjects/Registers.lsp|);
	return true;
}

private test bool tryParsingSingleModule()
{
	parseProject(|project://LL/src/tests/testData/isolatedProjects/SingleModule.lsp|);
	return true;
}

private test bool tryParsingMultipleModulesWithAlphabet()
{
	parseProject(|project://LL/src/tests/testData/isolatedProjects/MultipleModulesWithAlphabet.lsp|);
	return true;
}

private test bool tryParsingCompleteModule()
{
	parseProject(|project://LL/src/tests/testData/isolatedProjects/CompleteModule.lsp|);
	return true;
}

private test bool tryParsingComplexProject()
{
	parseProject(|project://LL/src/tests/testData/isolatedProjects/ComplexProject.lsp|);
	return true;
}

//////////////////////////////////////////////////////////////////////////////
// Tests for AST.
//////////////////////////////////////////////////////////////////////////////

private test bool tryImplodingOnlyAlphabet()
{
	parseProjectToAST(|project://LL/src/tests/testData/isolatedProjects/OnlyAlphabet.lsp|);
	return true;
}

private test bool tryImplodingOptions()
{
	parseProjectToAST(|project://LL/src/tests/testData/isolatedProjects/Options.lsp|);
	return true;
}

private test bool tryImplodingRegisters()
{
	parseProjectToAST(|project://LL/src/tests/testData/isolatedProjects/Registers.lsp|);
	return true;
}

private test bool tryImplodingSingleModule()
{
	parseProjectToAST(|project://LL/src/tests/testData/isolatedProjects/SingleModule.lsp|);
	return true;
}

private test bool tryImplodingMultipleModulesWithAlphabet()
{
	parseProjectToAST(|project://LL/src/tests/testData/isolatedProjects/MultipleModulesWithAlphabet.lsp|);
	return true;
}

private test bool tryImplodingCompleteModule()
{
	parseProjectToAST(|project://LL/src/tests/testData/isolatedProjects/CompleteModule.lsp|);
	return true;
}

private test bool tryImplodingComplexProject()
{
	parseProjectToAST(|project://LL/src/tests/testData/isolatedProjects/ComplexProject.lsp|);
	return true;
}