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

loc fileLocation = |project://LL/src/tests/correctTestData/isolatedProjects/notSet.txt|;
SyntaxTree emptySyntaxTree = syntaxTree([], (), (), (), []);

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
	/* Arrange */
	fileLocation.file = "OnlyAlphabet.lsp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingOptions()
{
	/* Arrange */
	fileLocation.file = "Options.lsp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingRegisters()
{
	/* Arrange */
	fileLocation.file = "Registers.lsp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingSingleModule()
{
	/* Arrange */
	fileLocation.file = "SingleModule.lsp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingMultipleModulesWithAlphabet()
{
	/* Arrange */
	fileLocation.file = "MultipleModulesWithAlphabet.lsp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingCompleteModule()
{
	/* Arrange */
	fileLocation.file = "CompleteModule.lsp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingComplexProject()
{
	/* Arrange */
	fileLocation.file = "ComplexProject.lsp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}