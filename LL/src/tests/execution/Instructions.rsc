//////////////////////////////////////////////////////////////////////////////
//
// Tests for rules.
// @brief        This file contains all tests for instructions that apply rules.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         20-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::execution::Instructions

import execution::DataStructures;
import execution::history::DataStructures;
import execution::instructions::Instructions;
import parsing::DataStructures;

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
	RuleMap rules = (0 : rule(reflections(false,false,false),[[1]],[[[2]]]));
	ExecutionHistory history = 
		[moduleExecution(0, [instructionExecution([])])];
	TileMap startingMap = [[0, 0], [1, 0]];
	ExecutionArtifact artifact = executionArtifact((), startingMap, history, []);
	
	TileMap expectedResult = [[0, 0], [2, 0]];
	
	/* Act */
	ExecutionArtifact result = 
		executeInstruction(artifact, rules, itterateRule(0));
	
	/* Assert */
	return expectedResult == result.currentState;
}

private test bool itterateRuleMultipleResults()
{
	/* Arrange */
	RuleMap rules = (0 : rule(reflections(false,false,false),[[1]],[[[2]]]));
	ExecutionHistory history = 
		[moduleExecution(0, [instructionExecution([])])];
	TileMap startingMap = [[1, 0], [1, 0]];
	ExecutionArtifact artifact = executionArtifact((), startingMap, history, []);
	
	list[TileMap] expectedResults = [[[1, 0], [2, 0]],
																	 [[2, 0], [1, 0]]];
	
	/* Act */
	ExecutionArtifact result 
		= executeInstruction(artifact, rules, itterateRule(0));

	/* Assert */
	return result.currentState in expectedResults;
}

private test bool executeRuleSingleResult()
{
	/* Arrange */
	RuleMap rules = (0 : rule(reflections(false,false,false),[[1]],[[[2]]]));
	ExecutionHistory history = 
		[moduleExecution(0, [instructionExecution([])])];
	TileMap startingMap = [[1, 1], [1, 1]];
	ExecutionArtifact artifact = executionArtifact((), startingMap, history, []);
	
	TileMap expectedResult = [[2, 2], [2, 2]];
	int itterations = 4;
	
	/* Act */
	ExecutionArtifact result = 
		executeInstruction(artifact, rules, executeRule(0, itterations));
	
	/* Assert */
	return expectedResult == result.currentState;
}

private test bool executeRuleMultipleResults()
{
	/* Arrange */
	RuleMap rules = (0 : rule(reflections(false,false,false),[[1]],[[[2]]]));
	ExecutionHistory history = 
		[moduleExecution(0, [instructionExecution([])])];
	TileMap startingMap = [[1, 1], [1, 1]];
	ExecutionArtifact artifact = executionArtifact((), startingMap, history, []);
	
	list[TileMap] expectedResults = [[[1, 2], [2, 2]],
																	 [[2, 1], [2, 2]],
																	 [[2, 2], [1, 2]],
																	 [[2, 2], [2, 1]]];
	int itterations = 3;
	
	/* Act */
	ExecutionArtifact result = 
		executeInstruction(artifact, rules, executeRule(0, itterations));

	/* Assert */
	return result.currentState in expectedResults;
}

private test bool executeGrammarOneRule()
{
	/* Arrange */
	RuleMap rules = (0 : rule(reflections(false,false,false),[[1]],[[[2]]]));
	ExecutionHistory history = 
		[moduleExecution(0, [instructionExecution([])])];
	TileMap startingMap = [[1, 1], [1, 1]];
	ExecutionArtifact artifact = executionArtifact((), startingMap, history, []);
	
	TileMap expectedResult = [[2, 2], [2, 2]];
	
	/* Act */
	ExecutionArtifact result = executeInstruction(artifact, rules, executeGrammar());
	
	/* Assert */
	return expectedResult == result.currentState;
}

public test bool executeGrammarMultipleRules()
{
	/* Arrange */
	RuleMap rules = (0 : rule(reflections(false,false,false),[[1]],[[[2]]]),
		1 : rule(reflections(false,false,false),[[2]],[[[3]]]));
	ExecutionHistory history = 
		[moduleExecution(0, [instructionExecution([])])];
	TileMap startingMap = [[1, 1], [1, 1]];
	ExecutionArtifact artifact = executionArtifact((), startingMap, history, []);
	
	TileMap expectedResult = [[3, 3], [3, 3]];
	
	/* Act */
	ExecutionArtifact result = executeInstruction(artifact, rules, executeGrammar());
	
	/* Assert */
	return expectedResult == result.currentState;
}