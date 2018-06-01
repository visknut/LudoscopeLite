//////////////////////////////////////////////////////////////////////////////
//
// Parsing tests for .sanr files.
// @brief        This file contains unit tests for parsing .sanr files to an AST
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         06-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::LevelSpecification

import parsing::DataStructures;
import parsing::Parser;
import tests::parsing::Utility;

import sanr::language::AST;
import sanr::DataStructures;

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
		|project://LL/src/tests/correctTestData/isolatedLevelSpecifications/adjacency.sanr|;
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

public test bool tryParsingOccurrence()
{
	/* Arrange */
	loc fileLocation = 
		|project://LL/src/tests/correctTestData/isolatedLevelSpecifications/occurrence.sanr|;
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

public test bool tryParsingOccurrenceAndContainment()
{
	/* Arrange */
	loc fileLocation = 
		|project://LL/src/tests/correctTestData/isolatedLevelSpecifications/occurrenceAndContainment.sanr|;
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}
