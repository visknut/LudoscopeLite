//////////////////////////////////////////////////////////////////////////////
//
// Parsing tests for .grm files.
// @brief        This file contains unit tests for parsing .grm files to an AST
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         06-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::Grammar

import parsing::Parser;
import tests::parsing::Utility;

loc fileLocation = |project://LL/src/tests/correctTestData/isolatedGrammars/notSet.txt|;
SyntaxTree emptySyntaxTree = syntaxTree([], (), (), (), []);

public bool runAllTests()
{
	return tryParsingAllOptions()
	&& tryParsingAllRuleSettings()
	&& tryParsingOnlyStart()
	&& tryParsingAllMemberTypes()
	&& tryParsingRuleWithMultipleRightHands()
	&& tryParsingSimpleRule();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser.
//////////////////////////////////////////////////////////////////////////////

private test bool tryParsingAllOptions()
{
	/* Arrange */
	fileLocation.file = "AllOptions.grm";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingAllRuleSettings()
{
	/* Arrange */
	fileLocation.file = "AllRuleSettings.grm";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingOnlyStart()
{
	/* Arrange */
	fileLocation.file = "OnlyStart.grm";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingAllMemberTypes()
{
	/* Arrange */
	fileLocation.file = "AllMemberTypes.grm";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingRuleWithMultipleRightHands()
{
	/* Arrange */
	fileLocation.file = "RuleWithMultipleRightHands.grm";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

// TODO:
private test bool tryParsingRuleWithNestedSymbol()
{
	/* Arrange */
	fileLocation.file = "RuleWithNestedSymbol.grm";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingSimpleRule()
{
	/* Arrange */
	fileLocation.file = "SimpleRule.grm";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}