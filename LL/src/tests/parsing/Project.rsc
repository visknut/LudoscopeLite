//////////////////////////////////////////////////////////////////////////////
//
// Parsing tests for .lsp files.
// @brief        This file contains unit tests for parsing .lsp files to an AST
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         06-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::Project

import IO;
import ParseTree;
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
	&& tryParsingComplexProject();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser.
//////////////////////////////////////////////////////////////////////////////

private bool projectParsingTest(loc fileToParse)
{
	Tree tree;
	/* First try parsing to a parse tree. */
	try {
		tree = parseProject(fileToParse);
	}
	catch ParseError(loc errorLocation):
	{
		print("Error: could not parse the file. \n@");
		println(errorLocation);
		return false;
	}
	catch Ambiguity(loc errorLocation, str usedSyntax, str parsedText):
	{
		print("Error: ambiguity found during parsing. \n@");
		println(errorLocation);
		return false;
	}
	/* Then try to implode the parse tree to an AST. */
	try {
		implodeProject(tree);
	}
	catch IllegalArgument(value v, str message):
	{
		println("Error: could not implode the parse tree to an AST");
		return false;
	}
	return true;
}

private test bool tryParsingOnlyAlphabet()
{
	return projectParsingTest(|project://LL/src/tests/testData/isolatedProjects/OnlyAlphabet.lsp|);
}

private test bool tryParsingOptions()
{
	return projectParsingTest(|project://LL/src/tests/testData/isolatedProjects/Options.lsp|);
}

private test bool tryParsingRegisters()
{
	return projectParsingTest(|project://LL/src/tests/testData/isolatedProjects/Registers.lsp|);
}

private test bool tryParsingSingleModule()
{
	return projectParsingTest(|project://LL/src/tests/testData/isolatedProjects/SingleModule.lsp|);
}

private test bool tryParsingMultipleModulesWithAlphabet()
{
	return projectParsingTest(|project://LL/src/tests/testData/isolatedProjects/MultipleModulesWithAlphabet.lsp|);
}

private test bool tryParsingCompleteModule()
{
	return projectParsingTest(|project://LL/src/tests/testData/isolatedProjects/CompleteModule.lsp|);
}

private test bool tryParsingComplexProject()
{
	return projectParsingTest(|project://LL/src/tests/testData/isolatedProjects/ComplexProject.lsp|);
}