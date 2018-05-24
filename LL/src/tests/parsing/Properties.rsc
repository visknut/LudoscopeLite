//////////////////////////////////////////////////////////////////////////////
//
// Parsing tests for .lpl files.
// @brief        This file contains unit tests for parsing .lpl files to an AST
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         06-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::Properties

import IO;
import List;
import parsing::DataStructures;
import parsing::Parser;
import parsing::transformations::TransformSyntaxTree;
import parsing::languages::alphabet::AST;
import tests::parsing::Utility;

import lpl::language::AST;
import lpl::DataStructures;

SyntaxTree emptySyntaxTree = syntaxTree([], (), (), (), [], []);

public bool runAllTests()
{
	return tryParsingAdjacency()
	&& tryParsingOccurrence()
	&& tryParsingOccurrenceAndContainment()
	&& nameNotFound()
	&& symbolNameFound()
	&& transformAdjacency()
	&& transformAdjacencyIncorrectType();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser.
//////////////////////////////////////////////////////////////////////////////

private test bool tryParsingAdjacency()
{
	/* Arrange */
	loc fileLocation = 
		|project://LL/src/tests/correctTestData/isolatedProperties/adjacency.lpl|;
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingOccurrence()
{
	/* Arrange */
	loc fileLocation = 
		|project://LL/src/tests/correctTestData/isolatedProperties/occurrence.lpl|;
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

private test bool tryParsingOccurrenceAndContainment()
{
	/* Arrange */
	loc fileLocation = 
		|project://LL/src/tests/correctTestData/isolatedProperties/occurrenceAndContainment.lpl|;
		
	/* Act */
	SyntaxTree syntaxTree = parseFile(fileLocation, emptySyntaxTree);
	
	/* Assert */
	return checkErrors(syntaxTree);
}

//////////////////////////////////////////////////////////////////////////////
// Tests for transformations.
//////////////////////////////////////////////////////////////////////////////

private test bool nameNotFound()
{
	/* Arrange */
	str structureName = "structureName";
	Name expectedResult = undefinedName(structureName);
	TransformationArtifact emptyArtifact = 
		transformationArtifact(ludoscopeProject([], (), [], [], []), []);
	
	/* Act */
	Name result  = findName(emptyArtifact, structureName);
	
	/* Assert */
	return expectedResult == result;
}

private test bool symbolNameFound()
{
	/* Arrange */
	str structureName = "symbolName";
	TransformationArtifact artifact = 
		transformationArtifact(ludoscopeProject([], ("alphabet" : ["symbolName"]),	[], [],[]), []);

	Name expectedResult = symbolName(0);
	
	/* Act */
	Name result  = findName(artifact, structureName);
	
	/* Assert */
	return expectedResult == result;
}

private test bool transformOccurrence()
{
	/* Arrange */
	TransformationArtifact artifact = 
		transformationArtifact(ludoscopeProject([], ("alphabet" : ["defined"]),	[], [], []), []);
	loc fileLocation =  
    |project://LL/src/tests/correctTestData/project0/Project.lsp|; 
	Property property = occurrence(1, "defined", "");
	
	lpl::DataStructures::Property expectedResult = occurrence(1, symbolIndex(0));

	/* Act */
	TransformationArtifact result = 
		transformProperty(artifact, property, fileLocation);
	
	/* Assert */
	return expectedResult == head(result.project.properties);
}

public test bool transformOccurrenceAndContainment()
{
	/* Arrange */
	TransformationArtifact artifact = 
		transformationArtifact(ludoscopeProject([], ("alphabet" : ["defined"]),	[], ["ruleName"], []), []);
	loc fileLocation =  
    |project://LL/src/tests/correctTestData/project0/Project.lsp|; 
	lpl::language::AST::Property property = occurrence(1, "defined", "in ruleName");
	
	lpl::DataStructures::Property expectedResult = 
		occurrence(1, symbolIndex(0), ruleIndex(0));

	/* Act */
	TransformationArtifact result = 
		transformProperty(artifact, property, fileLocation);
	
	/* Assert */
	return expectedResult == head(result.project.properties);
}

private test bool transformAdjacency()
{
	/* Arrange */
	TransformationArtifact artifact = 
		transformationArtifact(ludoscopeProject([], ("alphabet" : ["defined", "undefined"]),	[], ["ruleName"], []), []);
	loc fileLocation =  
    |project://LL/src/tests/correctTestData/project0/Project.lsp|; 
	lpl::language::AST::Property property = adjacency(true, "defined", "undefined");
	
	lpl::DataStructures::Property expectedResult = 
		adjacency(true, symbolIndex(0), symbolIndex(1));

	/* Act */
	TransformationArtifact result = 
		transformProperty(artifact, property, fileLocation);
	
	/* Assert */
	return expectedResult == head(result.project.properties);
}

private test bool transformAdjacencyIncorrectType()
{
	/* Arrange */
	TransformationArtifact artifact = 
		transformationArtifact(ludoscopeProject([], ("alphabet" : ["defined"]),	[], ["ruleName"], []), []);
	loc fileLocation =  
    |project://LL/src/tests/correctTestData/project0/Project.lsp|; 
	Property property = adjacency(true, "defined", "ruleName");

	/* Act */
	TransformationArtifact result = 
		transformProperty(artifact, property, fileLocation);
	
	/* Assert */
	return size(result.errors) == 1;
}