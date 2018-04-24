//////////////////////////////////////////////////////////////////////////////
//
// Parsing tests for .lsp files.
// @brief        This file contains unit tests for parsing .lsp files to an AST
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         06-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::Project

import parsing::Parser;
import tests::parsing::Utility;

public bool runAllTests()
{
	return tryParsingOnlyAlphabet()
	&& tryParsingOptions()
	&& tryParsingRegisters()
	&& tryParsingSingleModule()
	&& tryParsingMultipleModulesWithAlphabet()
	&& tryParsingCompleteModule()
	&& tryParsingComplexProject();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser.
//////////////////////////////////////////////////////////////////////////////

private test bool tryParsingOnlyAlphabet()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedProjects/OnlyAlphabet.lsp|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingOptions()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedProjects/Options.lsp|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingRegisters()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedProjects/Registers.lsp|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingSingleModule()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedProjects/SingleModule.lsp|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingMultipleModulesWithAlphabet()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedProjects/MultipleModulesWithAlphabet.lsp|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingCompleteModule()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedProjects/CompleteModule.lsp|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}

private test bool tryParsingComplexProject()
{
	SyntaxTree syntaxTree = parseFile(|project://LL/src/tests/testData/isolatedProjects/ComplexProject.lsp|, 
		syntaxTree([], (), (), (), []));
	return checkErrors(syntaxTree);
}