//////////////////////////////////////////////////////////////////////////////
//
// Tests for parsing & transforming complete projects
// @brief        Tests for parsing and transforming projects. If the parsing
//							 fails, the transformation tests will also fail, because they
//							 test the entire parsing pipeline (parsing + tranforming).
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         24-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::CompleteProjects

import IO;
import parsing::Parser;
import parsing::DataStructures;
import tests::parsing::Utility;
import parsing::Interface;

public bool runAllTests()
{
	return parseProject0()
	&& parseProject1()
	&& parseAndTransfromProject0()
	&& parseAndTransfromProject1()
	&& parseAndTransfromProject2()
	&& parseAndTransfromProject3();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for parser.
//////////////////////////////////////////////////////////////////////////////

private test bool parseProject0()
{
	/* Arrange */
	loc projectLocation = |project://LL/src/tests/correctTestData/project0/Project.lsp|;
	
	/* Act */
	SyntaxTree syntaxTree = parseCompleteProject(projectLocation);
	
	/* Assert */	
	return checkErrors(syntaxTree);
}

private test bool parseProject1()
{
	/* Arrange */
	loc projectLocation = |project://LL/src/tests/correctTestData/project1/Project.lsp|;
	
	/* Act */
	SyntaxTree syntaxTree = parseCompleteProject(projectLocation);
	
	/* Assert */	
	return checkErrors(syntaxTree);
}

//////////////////////////////////////////////////////////////////////////////
// Tests for transformer.
//////////////////////////////////////////////////////////////////////////////

public test bool parseAndTransfromProject0()
{
	/* Arrange */
	loc projectLocation = |project://LL/src/tests/correctTestData/project0/Project.lsp|;
	AlphabetMap expectedAlphabetMap = ("Alphabet":["*", "undefined", "defined"]);
	LudoscopeModule expectedModule = 
		ludoscopeModule(0,[],"Alphabet",
		[[1,1,1,1,1],
		 [1,1,1,1,1],
		 [1,1,1,1,1],
		 [1,1,1,1,1],
		 [1,1,1,1,1]],
		(0 : rule(reflections(false,false,false),[[1]],[[[2]]])),
		[executeRule(0, 100)]);
	LudoscopeProject expectedProject = ludoscopeProject([expectedModule], 
		expectedAlphabetMap, ["Module"], ["ruleName"], []);
	
	/* Act */
	TransformationArtifact artifact = parseAndTransform(projectLocation);
	
	/* Assert */	
	return checkErrors(artifact) && (\expectedProject := artifact.project);
}

private test bool parseAndTransfromProject1()
{
	/* Arrange */
	loc projectLocation = |project://LL/src/tests/correctTestData/project1/Project.lsp|;
	AlphabetMap expectedAlphabetMap = ("Alphabet":["*","undefined","defined"]);
	LudoscopeModule expectedModule1 = 
		ludoscopeModule(0 ,[],"Alphabet",
		[[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1]],
		(0 : rule(reflections(false,false,false),[[1]],[[[2]]]),
		1 : rule(reflections(false,false,false),[[2]],[[[1]]])),
		[executeRule(0, 100),
		itterateRule(1)]);
	LudoscopeModule expectedModule2 = 
		ludoscopeModule(1, [0],"Alphabet",
		[[1,1,1,1,1,1,1,1,1,1],
		 [1,1,1,1,1,1,1,1,1,1],
		 [1,1,1,1,1,1,1,1,1,1],
		 [1,1,1,1,1,1,1,1,1,1],
		 [1,1,1,1,1,1,1,1,1,1],
		 [1,1,1,1,1,1,1,1,1,1],
		 [1,1,1,1,1,1,1,1,1,1],
		 [1,1,1,1,1,1,1,1,1,1]],
		(2 : rule(reflections(false,false,false),[[1]],[[[2]]])),
		[itterateRule(2)]);
	LudoscopeProject expectedProject = ludoscopeProject([expectedModule1, expectedModule2], 
		expectedAlphabetMap, ["Module1", "Module2"], ["rule1", "rule2", "ruleName"], []);
		
	/* Act */
	TransformationArtifact artifact = parseAndTransform(projectLocation);
	
	/* Assert */	
	return checkErrors(artifact) && (\expectedProject := artifact.project);
}

private test bool parseAndTransfromProject2()
{
	/* Arrange */
	loc projectLocation = |project://LL/src/tests/correctTestData/project2/Project.lsp|;
	AlphabetMap expectedAlphabetMap = ("Alphabet":["*","undefined","defined"]);
	LudoscopeModule expectedModule = 
		ludoscopeModule(0,[],"Alphabet",
		[[1,1,1,1,1],
		 [1,1,1,1,1],
		 [1,1,1,1,1],
		 [1,1,1,1,1],
		 [1,1,1,1,1]],
		(0 : rule(reflections(false,false,false),[[1]],[[[2]]])),
		[executeGrammar()]);
	LudoscopeProject expectedProject = ludoscopeProject([expectedModule], 
		expectedAlphabetMap, ["Module"], ["ruleName"], []);
	
	/* Act */
	TransformationArtifact artifact = parseAndTransform(projectLocation);
	
	/* Assert */	
	return checkErrors(artifact) && (\expectedProject := artifact.project);
}

// TODO: Add project with lpl.
private test bool parseAndTransfromProject3()
{
	/* Arrange */
	
	/* Act */
	
	/* Assert */	
	return true;
}