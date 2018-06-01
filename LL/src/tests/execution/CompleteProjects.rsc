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

module tests::execution::CompleteProjects

import IO;

import execution::DataStructures;
import execution::Execution;
import parsing::DataStructures;
import tests::parsing::Utility;
import parsing::Interface;
import utility::TileMap;

import sanr::language::AST;
import sanr::DataStructures;
import analysis::sanrWrapper::PropertyHistory;

public bool runAllTests()
{
	return executeProject0();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for transformer.
//////////////////////////////////////////////////////////////////////////////

// TODO: extract parsed project to module.
// TOOD: generate tile maps.
public test bool executeProject0()
{
	/* Arrange */
	AlphabetMap alphabetMap = ();
	LudoscopeModule module1 = 
		ludoscopeModule("module1",[],"Alphabet",
		createTileMap("1", 5, 5),
		("ruleName" : rule(reflections(false,false,false),[["1"]],[[["2"]]])),
		[executeRule("ruleName", 100)]);
	LudoscopeProject project = ludoscopeProject([module1], (), specification([]));
		
	TileMap expectedOutput = createTileMap("2", 5, 5);

	/* Act */
	ExecutionArtifact result = executeProject(project);
	
	/* Assert */	
	return result.currentState == expectedOutput;
}