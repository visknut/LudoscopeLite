//////////////////////////////////////////////////////////////////////////////
//
// Parsing tests for .rcp files.
// @brief        This file contains unit tests for parsing .rcp files to an AST
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         06-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::Recipe

import IO;
import ParseTree;
import parsing::languages::recipe::Syntax;
import parsing::languages::recipe::AST;

public bool runAllTests()
{
	return tryParsingComment()
	&& tryParsingSingleInstruction()
	&& tryParsingDiceNotation()
	&& tryParsingBasicInstructions()
	&& tryParsingAdvancedInstructions()
	&& tryParsingAllInstructions();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser.
//////////////////////////////////////////////////////////////////////////////

private bool recipeParsingTest(loc fileToParse)
{
	Tree tree;
	/* First try parsing to a parse tree. */
	try {
		tree = parseRecipe(fileToParse);
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
		implodeRecipe(tree);
	}
	catch IllegalArgument(value v, str message):
	{
		println("Error: could not implode the parse tree to an AST");
		return false;
	}
	return true;
}

private test bool tryParsingComment()
{
	return recipeParsingTest(|project://LL/src/tests/testData/isolatedRecipes/Comment.rcp|);
}

private test bool tryParsingSingleInstruction()
{
	return recipeParsingTest(|project://LL/src/tests/testData/isolatedRecipes/SingleInstruction.rcp|);
}

private test bool tryParsingDiceNotation()
{
	return recipeParsingTest(|project://LL/src/tests/testData/isolatedRecipes/DiceNotation.rcp|);
}

private test bool tryParsingBasicInstructions()
{
	return recipeParsingTest(|project://LL/src/tests/testData/isolatedRecipes/BasicInstructions.rcp|);
}

private test bool tryParsingAdvancedInstructions()
{
	return recipeParsingTest(|project://LL/src/tests/testData/isolatedRecipes/AdvancedInstructions.rcp|);
}

private test bool tryParsingAllInstructions()
{
	return recipeParsingTest(|project://LL/src/tests/testData/isolatedRecipes/AllInstructions.rcp|);
}