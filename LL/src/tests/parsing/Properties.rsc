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
	return tryParsingContainment()
	&& nameNotFound()
	&& symbolNameFound()
	&& transformContainmentIncorrectType();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser.
//////////////////////////////////////////////////////////////////////////////

private test bool tryParsingContainment()
{
	/* Arrange */
	loc fileLocation = 
		|project://LL/src/tests/correctTestData/isolatedProperties/contaiment.lpl|;
		
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
	ContainerType expectedResult = undefinedName(structureName);
	TransformationArtifact emptyArtifact = 
		transformationArtifact(ludoscopeProject([], (), [], [], []), []);
	
	/* Act */
	ContainerType result  = findName(emptyArtifact, structureName);
	
	/* Assert */
	return expectedResult == result;
}

private test bool symbolNameFound()
{
	/* Arrange */
	str structureName = "symbolName";
	TransformationArtifact artifact = 
		transformationArtifact(ludoscopeProject([], ("alphabet" : ["symbolName"]),	[], [],[]), []);

	ContainerType expectedResult = symbolName(0);
	
	/* Act */
	ContainerType result  = findName(artifact, structureName);
	
	/* Assert */
	return expectedResult == result;
}

private test bool transformContainment()
{
	/* Arrange */
	TransformationArtifact artifact = 
		transformationArtifact(ludoscopeProject([], ("alphabet" : ["defined"]),	[], ["ruleName"], []), []);
	loc fileLocation =  
    |project://LL/src/tests/correctTestData/project0/Project.lsp|; 
	Property property = 
		parsing::languages::lpl::AST::containment("defined", "ruleName");
	
	parsing::DataStructures::Property expectedResult = 
		containment(symbol(0), ruleStructure(0));

	/* Act */
	TransformationArtifact result = 
		transformProperty(artifact, property, fileLocation);
	
	/* Assert */
	return expectedResult == head(result.project.properties);
}

private test bool transformContainmentIncorrectType()
{
	/* Arrange */
	TransformationArtifact artifact = 
		transformationArtifact(ludoscopeProject([], ("alphabet" : ["defined"]),	[], ["ruleName"], []), []);
	loc fileLocation =  
    |project://LL/src/tests/correctTestData/project0/Project.lsp|; 
	Property property = 
		parsing::languages::lpl::AST::containment("defined", "defined");

	/* Act */
	TransformationArtifact result = 
		transformProperty(artifact, property, fileLocation);
	
	/* Assert */
	return size(result.errors) == 1;
}