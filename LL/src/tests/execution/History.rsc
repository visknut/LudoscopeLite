//////////////////////////////////////////////////////////////////////////////
//
// Tests for execution history.
// @brief        This file contains all creating an history of the execution.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         20-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::execution::History

import IO;
import execution::Execution;
import execution::DataStructures;
import execution::instructions::Instructions;
import parsing::DataStructures;
import sanr::language::AST;

public bool runAllTests()
{
	return checkHistorySingleModule()
	&& checkHistoryMultipleModules();
}

private test bool checkHistorySingleModule()
{
	/* Arrange */
	RuleMap rules = ("rule1" : rule(reflections(false,false,false),[["1"]],[[["2"]]]),
		"rule2" : rule(reflections(false,false,false),[["2"]],[[["3"]]]));
	TileMap startingMap = [["1"]];
	LudoscopeModule module1 = 
		ludoscopeModule("module1", [], "alphabet", startingMap, rules, [executeGrammar()]);
	LudoscopeProject project = ludoscopeProject([module1], (), specification([]));
	
	Step step1 = step([["2"]], "module1", itterateRule("rule1"), "rule1", 0, coordinates(0,0));
	Step step2 = step([["3"]], "module1", itterateRule("rule2"), "rule2", 0, coordinates(0,0));

  ExecutionHistory expectedResult = [step1, step2];

	/* Act */
	ExecutionArtifact result = executeProject(project);
	
	/* Assert */
	return expectedResult == result.history;
}

public test bool checkHistoryMultipleModules()
{
  /* Arrange */
  RuleMap rules1 = ("rule1" : rule(reflections(false,false,false),[["1"]],[[["2"]]]),
    "rule2" : rule(reflections(false,false,false),[["2"]],[[["3"]]]));
  RuleMap rules2 = ("rule1" : rule(reflections(false,false,false),[["3"]],[[["2"]]]),
    "rule2" : rule(reflections(false,false,false),[["2"]],[[["1"]]]));
  TileMap startingMap = [["1"]];
  LudoscopeModule module1 = 
    ludoscopeModule("module1", [], "alphabet", startingMap, rules1, [executeGrammar()]);
  LudoscopeModule module2 = 
    ludoscopeModule("module2", ["module1"], "alphabet", startingMap, rules2, [executeGrammar()]);
  LudoscopeProject project = ludoscopeProject([module1, module2], (), specification([]));
  
  Step step1 = step([["2"]], "module1", itterateRule("rule1"), "rule1", 0, coordinates(0,0));
	Step step2 = step([["3"]], "module1", itterateRule("rule2"), "rule2", 0, coordinates(0,0));
  Step step3 = step([["2"]], "module2", itterateRule("rule1"), "rule1", 0, coordinates(0,0));
	Step step4 = step([["1"]], "module2", itterateRule("rule2"), "rule2", 0, coordinates(0,0));
  
  ExecutionHistory expectedResult = [step1, step2, step3, step4];
	
	/* Act */
	ExecutionArtifact result = executeProject(project);
	
	/* Assert */
	return expectedResult == result.history;
}