//////////////////////////////////////////////////////////////////////////////
//
// Parsing tests for .rcp files.
// @brief        This file contains unit tests for parsing .rcp files to an AST
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         06-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::Recipe

import parsing::languages::recipe::Syntax;
import parsing::languages::recipe::AST;

public bool runAllTests()
{
	return tryParsingComment()
	&& tryParsingSingleInstruction()
	&& tryParsingDiceNotation()
	&& tryParsingBasicInstructions()
	&& tryParsingAdvancedInstructions()
	&& tryParsingAllInstructions()
	&& tryImplodingComment()
	&& tryImplodingSingleInstruction()
	&& tryImplodingDiceNotation()
	&& tryImplodingBasicInstructions()
	&& tryImplodingAdvancedInstructions()
	&& tryImplodingAllInstructions();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser.
//////////////////////////////////////////////////////////////////////////////

private test bool tryParsingComment()
{
	parseRecipe(|project://LL/src/tests/testData/isolatedRecipes/Comment.rcp|);
	return true;
}

private test bool tryParsingSingleInstruction()
{
	parseRecipe(|project://LL/src/tests/testData/isolatedRecipes/SingleInstruction.rcp|);
	return true;
}

private test bool tryParsingDiceNotation()
{
	parseRecipe(|project://LL/src/tests/testData/isolatedRecipes/DiceNotation.rcp|);
	return true;
}

private test bool tryParsingBasicInstructions()
{
	parseRecipe(|project://LL/src/tests/testData/isolatedRecipes/BasicInstructions.rcp|);
	return true;
}

private test bool tryParsingAdvancedInstructions()
{
	parseRecipe(|project://LL/src/tests/testData/isolatedRecipes/AdvancedInstructions.rcp|);
	return true;
}

private test bool tryParsingAllInstructions()
{
	parseRecipe(|project://LL/src/tests/testData/isolatedRecipes/AllInstructions.rcp|);
	return true;
}

//////////////////////////////////////////////////////////////////////////////
// Tests for AST.
//////////////////////////////////////////////////////////////////////////////

private test bool tryImplodingComment()
{
	parseRecipeToAST(|project://LL/src/tests/testData/isolatedRecipes/Comment.rcp|);
	return true;
}

private test bool tryImplodingSingleInstruction()
{
	parseRecipeToAST(|project://LL/src/tests/testData/isolatedRecipes/SingleInstruction.rcp|);
	return true;
}

private test bool tryImplodingDiceNotation()
{
	parseRecipeToAST(|project://LL/src/tests/testData/isolatedRecipes/DiceNotation.rcp|);
	return true;
}

private test bool tryImplodingBasicInstructions()
{
	parseRecipeToAST(|project://LL/src/tests/testData/isolatedRecipes/BasicInstructions.rcp|);
	return true;
}

private test bool tryImplodingAdvancedInstructions()
{
	parseRecipeToAST(|project://LL/src/tests/testData/isolatedRecipes/AdvancedInstructions.rcp|);
	return true;
}

private test bool tryImplodingAllInstructions()
{
	parseRecipeToAST(|project://LL/src/tests/testData/isolatedRecipes/AllInstructions.rcp|);
	return true;
}