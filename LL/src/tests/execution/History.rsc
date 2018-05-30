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
import execution::history::DataStructures;
import execution::instructions::Instructions;
import parsing::DataStructures;

public bool runAllTests()
{
	return checkHistorySingleModule()
	&& checkHistoryMultipleModules();
}

private test bool checkHistorySingleModule()
{
	/* Arrange */
	RuleMap rules = (1 : rule(reflections(false,false,false),[[1]],[[[2]]]),
		2 : rule(reflections(false,false,false),[[2]],[[[3]]]));
	TileMap startingMap = [[1]];
	LudoscopeModule module1 = 
		ludoscopeModule(1, [], "alphabet", startingMap, rules, [executeGrammar()]);
	LudoscopeProject project = ludoscopeProject([module1], (), []);
	
  ExecutionHistory expectedResult = 
    [moduleExecution(
      "module1",
      [instructionExecution([
            ruleExecution(
              "rule1",
              0,
              coordinates(0,0)),
            ruleExecution(
              "rule2",
              0,
              coordinates(0,0))
          ])])];
	
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
  LudoscopeProject project = ludoscopeProject([module1, module2], (), []);
  
  ExecutionHistory expectedResult = 
    [moduleExecution(
      "module1",
      [instructionExecution([
            ruleExecution(
              "rule1",
              0,
              coordinates(0,0)),
            ruleExecution(
              "rule2",
              0,
              coordinates(0,0))
          ])]),
    moduleExecution(
      "module2",
      [instructionExecution([
            ruleExecution(
              "rule1",
              0,
              coordinates(0,0)),
            ruleExecution(
              "rule2",
              0,
              coordinates(0,0))
          ])])];
	
	/* Act */
	ExecutionArtifact result = executeProject(project);
	
	/* Assert */
	return expectedResult == result.history;
}