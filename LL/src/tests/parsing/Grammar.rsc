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
SyntaxTree emptySyntaxTree = syntaxTree([], (), (), (), [], []);

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
	fileLocation.file = "allOptions.grm";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingAllRuleSettings()
{
	/* Arrange */
	fileLocation.file = "allRuleSettings.grm";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingOnlyStart()
{
	/* Arrange */
	fileLocation.file = "onlyStart.grm";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

public test bool tryParsingAllMemberTypes()
{
	/* Arrange */
	fileLocation.file = "allMemberTypes.grm";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingRuleWithMultipleRightHands()
{
	/* Arrange */
	fileLocation.file = "ruleWithMultipleRightHands.grm";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}


private test bool tryParsingSimpleRule()
{
	/* Arrange */
	fileLocation.file = "simpleRule.grm";
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}