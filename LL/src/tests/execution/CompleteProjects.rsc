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

public bool runAllTests()
{
	return executeProject0();
}

//////////////////////////////////////////////////////////////////////////////
// Tests for transformer.
//////////////////////////////////////////////////////////////////////////////

// TODO: extract parsed project to module.
private test bool executeProject0()
{
	/* Arrange */
	AlphabetMap alphabetMap = ("Alphabet":["*", "undefined", "defined"]);
	LudoscopeModule module1 = 
		ludoscopeModule(0,[],"Alphabet",
		[[1,1,1,1,1],
		 [1,1,1,1,1],
		 [1,1,1,1,1],
		 [1,1,1,1,1],
		 [1,1,1,1,1]],
		(0 : rule(reflections(false,false,false),[[1]],[[[2]]])),
		[executeRule(0, 100)]);
		
	TileMap expectedOutput =
		[[2,2,2,2,2],
		 [2,2,2,2,2],
		 [2,2,2,2,2],
		 [2,2,2,2,2],
		 [2,2,2,2,2]];
	
	LudoscopeProject project = ludoscopeProject([module1], 
		alphabetMap, ["Module"], ["ruleName"], []);
	
	/* Act */
	ExecutionArtifact result = executeProject(project);
	
	/* Assert */	
	return result.currentState == expectedOutput;
}