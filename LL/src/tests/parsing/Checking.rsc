//////////////////////////////////////////////////////////////////////////////
//
// Tests for checks done on the AST
// @brief        Tests for checks done on the AST.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         24-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::Checking

import parsing::Parser;

import parsing::check::CheckVersion;
import parsing::check::Maps;

loc projectLocation = |project://LL/src/tests/incorrectTestData/isolatedProjects/notSet.txt|;
loc grammarLocation = |project://LL/src/tests/incorrectTestData/isolatedGrammars/notSet.txt|;
SyntaxTree emptySyntaxTree = syntaxTree([], (), (), (), [], []);

public bool runAllTests()
{
	return detectIncorrectVesionProject()
	&& detectIncorrectVersionGrammar()
	&& detectIncorrectMapSize()
	&& detectIncorrectMapType()
	&& detectMapSizeMismatch();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser.
//////////////////////////////////////////////////////////////////////////////

private test bool detectIncorrectVesionProject()
{
	/* Arrange */
	projectLocation.file = "wrongVersion.lsp";
	
	/* Act */
	SyntaxTree syntaxTree = parseFile(projectLocation, emptySyntaxTree);
	syntaxTree = checkVersion(syntaxTree);
	
	/* Assert */
	return version(str version) := syntaxTree.errors[0];
}

private test bool detectIncorrectVersionGrammar()
{
	/* Arrange */
	grammarLocation.file = "wrongVersion.grm";
	
	/* Act */
	SyntaxTree syntaxTree = parseFile(grammarLocation, emptySyntaxTree);
	syntaxTree = checkVersion(syntaxTree);
	
	/* Assert */
	return version(str version) := syntaxTree.errors[0];
}

private test bool detectIncorrectMapSize()
{
	/* Arrange */
	grammarLocation.file = "wrongMapSize.grm";
	
	/* Act */
	SyntaxTree syntaxTree = parseFile(grammarLocation, emptySyntaxTree);
	syntaxTree = checkMapSize(syntaxTree);
	
	/* Assert */
	return mapSize(int size, int symbols, loc fileLocation) := syntaxTree.errors[0];
}

private test bool detectIncorrectMapType()
{
	/* Arrange */
	grammarLocation.file = "unsupportedMapTypes.grm";
	
	/* Act */
	SyntaxTree syntaxTree = parseFile(grammarLocation, emptySyntaxTree);
	syntaxTree = checkMapTypes(syntaxTree);
	
	/* Assert */
	return mapType(str mapType, loc fileLocation) := syntaxTree.errors[0];
}

private test bool detectMapSizeMismatch()
{
	/* Arrange */
	grammarLocation.file = "mismatchingMapSize.grm";
	
	/* Act */
	SyntaxTree syntaxTree = parseFile(grammarLocation, emptySyntaxTree);
	syntaxTree = compareLeftAndRightHandSize(syntaxTree);
	
	/* Assert */
	return rightAndLeftHandSize(int leftWidth, int leftHeight, 
		int rightWidth, int rightHeight, loc fileLocation) := syntaxTree.errors[0];
}