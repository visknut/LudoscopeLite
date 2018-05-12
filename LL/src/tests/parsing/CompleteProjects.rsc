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
	&& parseAndTransfromProject2();
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

private test bool parseAndTransfromProject0()
{
	/* Arrange */
	loc projectLocation = |project://LL/src/tests/correctTestData/project0/Project.lsp|;
	AlphabetMap expectedAlphabetMap = ("Alphabet":("defined":2,"*":0,"undefined":1));
	LudoscopeModule expectedModule = 
		ludoscopeModule("Module",[],"Alphabet",
		[[1,1,1,1,1],
		 [1,1,1,1,1],
		 [1,1,1,1,1],
		 [1,1,1,1,1],
		 [1,1,1,1,1]],
		("ruleName":rule(reflections(false,false,false),[[1]],[[[2]]])),
		[executeRule("ruleName",100)]);
	LudoscopeProject expectedProject = ludoscopeProject([expectedModule], 
		expectedAlphabetMap);
	
	/* Act */
	TransformationArtifact artifact = parseAndTransform(projectLocation);
	
	/* Assert */	
	return checkErrors(artifact) && (\expectedProject := artifact.project);
}

private test bool parseAndTransfromProject1()
{
	/* Arrange */
	loc projectLocation = |project://LL/src/tests/correctTestData/project1/Project.lsp|;
	AlphabetMap expectedAlphabetMap = ("Alphabet":("defined":2,"*":0,"undefined":1));
	LudoscopeModule expectedModule1 = 
		ludoscopeModule("Module1",[],"Alphabet",
		[[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1]],
		("rule1":rule(reflections(false,false,false),[[1]],[[[2]]]),
		"rule2":rule(reflections(false,false,false),[[2]],[[[1]]])),
		[executeRule("rule1",100),
		itterateRule("rule2")]);
	LudoscopeModule expectedModule2 = 
		ludoscopeModule("Module2",["Module1"],"Alphabet",
		[[1,1,1,1,1,1,1,1,1,1],
		 [1,1,1,1,1,1,1,1,1,1],
		 [1,1,1,1,1,1,1,1,1,1],
		 [1,1,1,1,1,1,1,1,1,1],
		 [1,1,1,1,1,1,1,1,1,1],
		 [1,1,1,1,1,1,1,1,1,1],
		 [1,1,1,1,1,1,1,1,1,1],
		 [1,1,1,1,1,1,1,1,1,1]],
		("ruleName":rule(reflections(false,false,false),[[1]],[[[2]]])),
		[itterateRule("ruleName")]);
	LudoscopeProject expectedProject = ludoscopeProject([expectedModule1, expectedModule2], 
		expectedAlphabetMap);
		
	/* Act */
	TransformationArtifact artifact = parseAndTransform(projectLocation);
	
	/* Assert */	
	return checkErrors(artifact) && (\expectedProject := artifact.project);
}

private test bool parseAndTransfromProject2()
{
	/* Arrange */
	loc projectLocation = |project://LL/src/tests/correctTestData/project2/Project.lsp|;
	AlphabetMap expectedAlphabetMap = ("Alphabet":("defined":2,"*":0,"undefined":1));
	LudoscopeModule expectedModule = 
		ludoscopeModule("Module",[],"Alphabet",
		[[1,1,1,1,1],
		 [1,1,1,1,1],
		 [1,1,1,1,1],
		 [1,1,1,1,1],
		 [1,1,1,1,1]],
		("ruleName":rule(reflections(false,false,false),[[1]],[[[2]]])),
		[executeGrammar()]);
	LudoscopeProject expectedProject = ludoscopeProject([expectedModule], 
		expectedAlphabetMap);
	
	/* Act */
	TransformationArtifact artifact = parseAndTransform(projectLocation);
	println(artifact);
	
	/* Assert */	
	return checkErrors(artifact) && (\expectedProject := artifact.project);
}