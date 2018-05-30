//////////////////////////////////////////////////////////////////////////////
//
// Tests for rules.
// @brief        This file contains all tests for instructions that apply rules.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         20-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::execution::Instructions

import IO;
import execution::DataStructures;
import execution::instructions::Instructions;
import analysis::lplWrapper::PropertyHistory;
import parsing::DataStructures;
import lpl::DataStructures;
import lpl::language::AST;

public bool runAllTests()
{
	return itterateRuleSingleResult()
	&& itterateRuleMultipleResults()
	&& executeRuleSingleResult()
	&& executeRuleMultipleResults()
	&& executeGrammarOneRule()
	&& executeGrammarMultipleRules();
}

public test bool itterateRuleSingleResult()
{
 /* Arrange */
 RuleMap rules = ("rule" : rule(reflections(false,false,false),[["1"]],[[["2"]]]));
 ExecutionHistory history = 
  [moduleExecution("module", [instructionExecution([])])];
 TileMap startingMap = [["0", "0"], ["1", "0"]];
 PropertyReport emptyReport = initializeReport(2,	2, specification([]));
 ExecutionArtifact artifact = executionArtifact((), startingMap, history, emptyReport, []);
 
 TileMap expectedResult = [["0", "0"], ["2", "0"]];
 
 /* Act */
 ExecutionArtifact result = 
  executeInstruction(artifact, rules, itterateRule("rule"));
 
 /* Assert */
 return expectedResult == result.currentState;
}
 
private test bool itterateRuleMultipleResults()
{
 /* Arrange */
 RuleMap rules = ("rule" : rule(reflections(false,false,false),[["1"]],[[["2"]]]));
 ExecutionHistory history = 
  [moduleExecution("module", [instructionExecution([])])];
 TileMap startingMap = [["1", "0"], ["1", "0"]];
 PropertyReport emptyReport = initializeReport(2,	2, specification([]));
 ExecutionArtifact artifact = executionArtifact((), startingMap, history, emptyReport, []);
 
 list[TileMap] expectedResults = [[["1", "0"], ["2", "0"]],
                  [["2", "0"], ["1", "0"]]];
 
 /* Act */
 ExecutionArtifact result 
  = executeInstruction(artifact, rules, itterateRule("rule"));
 
 /* Assert */
 return result.currentState in expectedResults;
}
 
private test bool executeRuleSingleResult()
{
 /* Arrange */
 RuleMap rules = ("rule" : rule(reflections(false,false,false),[["1"]],[[["2"]]]));
 ExecutionHistory history = 
  [moduleExecution("module", [instructionExecution([])])];
 TileMap startingMap = [["1", "1"], ["1", "1"]];
 PropertyReport emptyReport = initializeReport(2,	2, specification([]));
 ExecutionArtifact artifact = executionArtifact((), startingMap, history, emptyReport, []);
 
 TileMap expectedResult = [["2", "2"], ["2", "2"]];
 int itterations = 4;
 
 /* Act */
 ExecutionArtifact result = 
  executeInstruction(artifact, rules, executeRule("rule", itterations));
 
 /* Assert */
 return expectedResult == result.currentState;
}
 
private test bool executeRuleMultipleResults()
{
 /* Arrange */
 RuleMap rules = ("rule" : rule(reflections(false,false,false),[["1"]],[[["2"]]]));
 ExecutionHistory history = 
  [moduleExecution("module", [instructionExecution([])])];
 TileMap startingMap = [["1", "1"], ["1", "1"]];
 PropertyReport emptyReport = initializeReport(2,	2, specification([]));
 ExecutionArtifact artifact = executionArtifact((), startingMap, history, emptyReport, []);
 
 list[TileMap] expectedResults = [[["1", "2"], ["2", "2"]],
                  [["2", "1"], ["2", "2"]],
                  [["2", "2"], ["1", "2"]],
                  [["2", "2"], ["2", "1"]]];
 int itterations = 3;
 
 /* Act */
 ExecutionArtifact result = 
  executeInstruction(artifact, rules, executeRule("rule", itterations));
 
 /* Assert */
 return result.currentState in expectedResults;
}

private test bool executeGrammarOneRule()
{
 /* Arrange */
 RuleMap rules = ("rule" : rule(reflections(false,false,false),[["1"]],[[["2"]]]));
 ExecutionHistory history = 
  [moduleExecution("module", [instructionExecution([])])];
 TileMap startingMap = [["1", "1"], ["1", "1"]];
 PropertyReport emptyReport = initializeReport(2,	2, specification([]));
 ExecutionArtifact artifact = executionArtifact((), startingMap, history, emptyReport, []);
 
 TileMap expectedResult = [["2", "2"], ["2", "2"]];
 
 /* Act */
 ExecutionArtifact result = executeInstruction(artifact, rules, executeGrammar());
 
 /* Assert */
 return expectedResult == result.currentState;
}
 
public test bool executeGrammarMultipleRules()
{
 /* Arrange */
 RuleMap rules = ("rule1" : rule(reflections(false,false,false),[["1"]],[[["2"]]]),
  "rule2" : rule(reflections(false,false,false),[["2"]],[[["3"]]]));
 ExecutionHistory history = 
  [moduleExecution("module", [instructionExecution([])])];
 TileMap startingMap = [["1", "1"], ["1", "1"]];
 PropertyReport emptyReport = initializeReport(2,	2, specification([]));
 ExecutionArtifact artifact = executionArtifact((), startingMap, history, emptyReport, []);
 
 TileMap expectedResult = [["3", "3"], ["3", "3"]];
 
 /* Act */
 ExecutionArtifact result = executeInstruction(artifact, rules, executeGrammar());
 
 /* Assert */
 return expectedResult == result.currentState;
}