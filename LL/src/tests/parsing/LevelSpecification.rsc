//////////////////////////////////////////////////////////////////////////////
//
// Parsing tests for .lpl files.
// @brief        This file contains unit tests for parsing .lpl files to an AST
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         06-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::LevelSpecification

import parsing::DataStructures;
import parsing::Parser;
import tests::parsing::Utility;

import lpl::language::AST;
import lpl::DataStructures;

SyntaxTree emptySyntaxTree = syntaxTree([], (), (), (), [], []);

public bool runAllTests()
{
	return tryParsingAdjacency()
	&& tryParsingOccurrence()
	&& tryParsingOccurrenceAndContainment();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser.
//////////////////////////////////////////////////////////////////////////////

public test bool tryParsingAdjacency()
{
	/* Arrange */
	loc fileLocation = 
		|project://LL/src/tests/correctTestData/isolatedLevelSpecifications/adjacency.lpl|;
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

public test bool tryParsingOccurrence()
{
	/* Arrange */
	loc fileLocation = 
		|project://LL/src/tests/correctTestData/isolatedLevelSpecifications/occurrence.lpl|;
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

public test bool tryParsingOccurrenceAndContainment()
{
	/* Arrange */
	loc fileLocation = 
		|project://LL/src/tests/correctTestData/isolatedLevelSpecifications/occurrenceAndContainment.lpl|;
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}
