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
import lpl::language::AST;
import util::TileMap;
import parsing::languages::alphabet::AST;

public bool runAllTests()
{
	return parseProject0()
	&& parseProject1()
	&& parseProject2()
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

private test bool parseProject2()
{
	/* Arrange */
	loc projectLocation = |project://LL/src/tests/correctTestData/project2/Project.lsp|;
	
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
	AlphabetMap expectedAlphabetMap = ("Alphabet":alphabet(
        tileMap(1,1),
        [
          symbol("*","#B0B0B0","#404040","",""),
          symbol("undefined","#404040","#B0B0B0","abbreviation=\"u\"",""),
          symbol("defined","#404040","#B0B0B0","abbreviation=\"d\"","")
        ]));
	LudoscopeModule expectedModule = 
		ludoscopeModule("Module",[],"Alphabet",
		createTileMap("undefined", 5, 5),
		("ruleName" : rule(reflections(false,false,false),[["undefined"]],[[["defined"]]])),
		[executeRule("ruleName", 100)]);
	LudoscopeProject expectedResult = ludoscopeProject([expectedModule], 
		expectedAlphabetMap, specification([]));
	
	/* Act */
	TransformationArtifact artifact = parseAndTransform(projectLocation);
	
	/* Assert */	
	return checkErrors(artifact) && (/expectedResult := artifact.project);
}

public test bool parseAndTransfromProject1()
{
	/* Arrange */
	loc projectLocation = |project://LL/src/tests/correctTestData/project1/Project.lsp|;
	AlphabetMap expectedAlphabetMap = ("Alphabet":alphabet(
      tileMap(1,1),
      [
        symbol("*","#B0B0B0","#404040","",""),
        symbol("undefined","#404040","#B0B0B0","abbreviation=\"u\"",""),
        symbol("defined","#000000","#FFFFFF","abbreviation=\"d\"","")
      ]));
	LudoscopeModule expectedModule1 = 
		ludoscopeModule("Module1" ,[],"Alphabet",
		createTileMap("undefined", 10, 10),
		("rule1" : rule(reflections(false,false,false),[["undefined"]],[[["defined"]]]),
		"rule2" : rule(reflections(false,false,false),[["defined"]],[[["undefined"]]])),
		[executeRule("rule1", 100),
		itterateRule("rule2")]);
	LudoscopeModule expectedModule2 = 
		ludoscopeModule("Module2", ["Module1"],"Alphabet",
		createTileMap("undefined", 10, 10),
		("ruleName" : rule(reflections(false,false,false),[["undefined"]],[[["defined"]]])),
		[itterateRule("ruleName")]);
	LudoscopeProject expectedResult = ludoscopeProject([expectedModule1, expectedModule2], 
		expectedAlphabetMap, specification([]));
		
	/* Act */
	TransformationArtifact artifact = parseAndTransform(projectLocation);
	
	/* Assert */	
	return checkErrors(artifact) && (/expectedResult := artifact.project);
}

public test bool parseAndTransfromProject2()
{
	/* Arrange */
	loc projectLocation = |project://LL/src/tests/correctTestData/project2/Project.lsp|;
	AlphabetMap expectedAlphabetMap = ("Alphabet":alphabet(
        tileMap(1,1),
        [
          symbol("*","#B0B0B0","#404040","",""),
          symbol("undefined","#404040","#B0B0B0","abbreviation=\"u\"",""),
          symbol("defined","#404040","#B0B0B0","abbreviation=\"d\"","")
        ]));
	LudoscopeModule expectedModule = 
		ludoscopeModule("Module",[],"Alphabet",
		createTileMap("undefined", 5, 5),
		("ruleName" : rule(reflections(false,false,false),[["undefined"]],[[["defined"]]])),
		[executeGrammar()]);
	LudoscopeProject expectedProject = ludoscopeProject(
		[expectedModule], 
		expectedAlphabetMap,
		specification([property(none(), tileSet("defined", nowAdjacent("undefined"), everAny()))]));
	
	/* Act */
	TransformationArtifact artifact = parseAndTransform(projectLocation);
	
	/* Assert */	
	return checkErrors(artifact) && (\expectedProject := artifact.project);
}