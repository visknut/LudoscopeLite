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
SyntaxTree emptySyntaxTree = syntaxTree([], (), (), (), [], []);

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
	fileLocation.file = "onlyAlphabet.lsp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingOptions()
{
	/* Arrange */
	fileLocation.file = "options.lsp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingRegisters()
{
	/* Arrange */
	fileLocation.file = "registers.lsp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingSingleModule()
{
	/* Arrange */
	fileLocation.file = "singleModule.lsp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingMultipleModulesWithAlphabet()
{
	/* Arrange */
	fileLocation.file = "multipleModulesWithAlphabet.lsp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingCompleteModule()
{
	/* Arrange */
	fileLocation.file = "completeModule.lsp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingComplexProject()
{
	/* Arrange */
	fileLocation.file = "complexProject.lsp";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}