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
	
	/* Act */
	ContainerType result  = findName(emptySyntaxTree, structureName);
	
	/* Assert */
	return expectedResult == result;
}

private test bool symbolNameFound()
{
	/* Arrange */
	str structureName = "symbolName";
	 parsing::languages::alphabet::AST::Alphabet alphabet = 
		alphabet(tileMap(1, 1), [symbol(structureName, "", "", "", "")]);
	SyntaxTree syntaxTree = 
		syntaxTree([], (), ("alphabet" : alphabet), (), [],	[]);

	ContainerType expectedResult = symbolName(structureName);
	
	/* Act */
	ContainerType result  = findName(syntaxTree, structureName);
	
	/* Assert */
	return expectedResult == result;
}

private test bool transformContainment()
{
	/* Arrange */
	TransformationArtifact emptyArtifact = 
		transformationArtifact(ludoscopeProject([], (),	[]), []);
	loc fileLocation = 
		|project://LL/src/tests/correctTestData/project0/Project.lsp|;
	SyntaxTree syntaxTree = parseCompleteProject(fileLocation);
	Property property = 
		parsing::languages::lpl::AST::containment("defined", "ruleName");

	parsing::DataStructures::Property expectedResult = 
		containment(symbol("defined"), ruleStructure("ruleName"));

	/* Act */
	TransformationArtifact result = 
		transformProperty(emptyArtifact, syntaxTree, property, fileLocation);
	
	/* Assert */
	return expectedResult == head(result.project.properties);
}

private test bool transformContainmentIncorrectType()
{
	/* Arrange */
	TransformationArtifact emptyArtifact = 
		transformationArtifact(ludoscopeProject([], (),	[]), []);
	loc fileLocation = 
		|project://LL/src/tests/correctTestData/project0/Project.lsp|;
	SyntaxTree syntaxTree = parseCompleteProject(fileLocation);
	Property property = 
		parsing::languages::lpl::AST::containment("defined", "defined");

	/* Act */
	TransformationArtifact result = 
		transformProperty(emptyArtifact, syntaxTree, property, fileLocation);
	
	/* Assert */
	return size(result.errors) == 1;
}