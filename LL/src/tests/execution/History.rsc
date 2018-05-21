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
	LudoscopeProject project = ludoscopeProject([module1], (), [], [], []);
	
	ExecutionHistory expectedResult = 
		[moduleExecution(
      1,
      [instructionExecution([
            ruleExecution(
              1,
              0,
              coordinates(0,0)),
            ruleExecution(
              2,
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
	RuleMap rules1 = (0 : rule(reflections(false,false,false),[[1]],[[[2]]]),
		1 : rule(reflections(false,false,false),[[2]],[[[3]]]));
	RuleMap rules2 = (2 : rule(reflections(false,false,false),[[3]],[[[2]]]),
		3 : rule(reflections(false,false,false),[[2]],[[[1]]]));
	TileMap startingMap = [[1]];
	LudoscopeModule module1 = 
		ludoscopeModule(0, [], "alphabet", startingMap, rules1, [executeGrammar()]);
	LudoscopeModule module2 = 
		ludoscopeModule(1, [0], "alphabet", startingMap, rules2, [executeGrammar()]);
	LudoscopeProject project = ludoscopeProject([module1, module2], (), [], [], []);
	
	ExecutionHistory expectedResult = 
		[moduleExecution(
      0,
      [instructionExecution([
            ruleExecution(
              0,
              0,
              coordinates(0,0)),
            ruleExecution(
              1,
              0,
              coordinates(0,0))
          ])]),
    moduleExecution(
      1,
      [instructionExecution([
            ruleExecution(
              2,
              0,
              coordinates(0,0)),
            ruleExecution(
              3,
              0,
              coordinates(0,0))
          ])])];
	
	/* Act */
	ExecutionArtifact result = executeProject(project);
	
	/* Assert */
	return expectedResult == result.history;
}