//////////////////////////////////////////////////////////////////////////////
//
// Tests for parsing complete projects
// @brief        Tests for parsing complete projects.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         24-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::CompleteProjects

import parsing::Parser;
import parsing::DataStructures;
import tests::parsing::Utility;

public bool runAllTests()
{
	return parseProject0()
	&& parseProject1();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser.
//////////////////////////////////////////////////////////////////////////////

private test bool parseProject0()
{
	/* Arrange */
	loc projectLocation = |project://LL/src/tests/correctTestData/project0/Project.lsp|;
	
	/* Act */
	SyntaxTree syntaxTree = 
		parseCompleteProject(projectLocation);
	
	/* Assert */	
	return checkErrors(syntaxTree);
}

private test bool parseProject1()
{
	/* Arrange */
	loc projectLocation = |project://LL/src/tests/correctTestData/project1/Project.lsp|;
	
	/* Act */
	SyntaxTree syntaxTree = 
		parseCompleteProject(projectLocation);
	
	/* Assert */	
	return checkErrors(syntaxTree);
}
