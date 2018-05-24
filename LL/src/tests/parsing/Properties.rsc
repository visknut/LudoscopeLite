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
import parsing::languages::lpl::AST;
import tests::parsing::Utility;

SyntaxTree emptySyntaxTree = syntaxTree([], (), (), (), [], []);

public bool runAllTests()
{
	return tryParsingAdjecency()
	&& tryParsingOccurrence()
	&& tryParsingOccurrenceAndContainment()
	&& nameNotFound()
	&& symbolNameFound()
	&& transformAdjecency()
	&& transformAdjecencyIncorrectType();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser.
//////////////////////////////////////////////////////////////////////////////

private test bool tryParsingAdjecency()
{
	/* Arrange */
	loc fileLocation = 
		|project://LL/src/tests/correctTestData/isolatedProperties/adjecent.lpl|;
		
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
	Property property = 
		parsing::languages::lpl::AST::occurrence(1, "defined", "");
	
	parsing::DataStructures::Property expectedResult = 
		occurrence(1, symbolIndex(0));

	/* Act */
	TransformationArtifact result = 
		transformProperty(artifact, property, fileLocation);
	
	/* Assert */
	return expectedResult == head(result.project.properties);
}

private test bool transformOccurrenceAndContainment()
{
	/* Arrange */
	TransformationArtifact artifact = 
		transformationArtifact(ludoscopeProject([], ("alphabet" : ["defined"]),	[], ["ruleName"], []), []);
	loc fileLocation =  
    |project://LL/src/tests/correctTestData/project0/Project.lsp|; 
	Property property = 
		parsing::languages::lpl::AST::occurrence(1, "defined", "ruleName");
	
	parsing::DataStructures::Property expectedResult = 
		occurrence(1, symbolIndex(0), ruleIndex(0));

	/* Act */
	TransformationArtifact result = 
		transformProperty(artifact, property, fileLocation);
	
	/* Assert */
	return expectedResult == head(result.project.properties);
}

private test bool transformAdjecency()
{
	/* Arrange */
	TransformationArtifact artifact = 
		transformationArtifact(ludoscopeProject([], ("alphabet" : ["defined", "undefined"]),	[], ["ruleName"], []), []);
	loc fileLocation =  
    |project://LL/src/tests/correctTestData/project0/Project.lsp|; 
	Property property = 
		parsing::languages::lpl::AST::adjecent("defined", "undefined");
	
	parsing::DataStructures::Property expectedResult = 
		adjecent(symbolIndex(0), symbolIndex(1));

	/* Act */
	TransformationArtifact result = 
		transformProperty(artifact, property, fileLocation);
	
	/* Assert */
	return expectedResult == head(result.project.properties);
}

private test bool transformAdjecencyIncorrectType()
{
	/* Arrange */
	TransformationArtifact artifact = 
		transformationArtifact(ludoscopeProject([], ("alphabet" : ["defined"]),	[], ["ruleName"], []), []);
	loc fileLocation =  
    |project://LL/src/tests/correctTestData/project0/Project.lsp|; 
	Property property = 
		parsing::languages::lpl::AST::adjecent("defined", "ruleName");

	/* Act */
	TransformationArtifact result = 
		transformProperty(artifact, property, fileLocation);
	
	/* Assert */
	return size(result.errors) == 1;
}