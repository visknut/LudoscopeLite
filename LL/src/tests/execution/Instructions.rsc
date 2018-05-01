//////////////////////////////////////////////////////////////////////////////
//
// Tests for rules.
// @brief        This file contains all tests for instructions that apply rules.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         20-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::execution::Instructions

import execution::instructions::Instructions;
import parsing::DataStructures;
import IO;

public bool runAllTests()
{
	return itterateRuleSingleResult()
	&& itterateRuleMultipleResults()
	&& executeRuleSingleResult()
	&& executeRuleMultipleResults();
}


private test bool itterateRuleSingleResult()
{
	/* Arrange */
	RuleMap rules = ("rule" : rule(reflections(false,false,false),[[1]],[[[2]]]));
	TileMap startingMap = [[0, 0], [1, 0]];
	TileMap expectedResult = [[0, 0], [2, 0]];
	
	/* Act */
	TileMap result = executeInstruction(startingMap, rules, itterateRule("rule"));
	
	/* Assert */
	return expectedResult == result;
}

private test bool itterateRuleMultipleResults()
{
	/* Arrange */
	RuleMap rules = ("rule" : rule(reflections(false,false,false),[[1]],[[[2]]]));
	TileMap startingMap = [[1, 0], [1, 0]];
	list[TileMap] expectedResults = [[[1, 0], [2, 0]],
																	 [[2, 0], [1, 0]]];
	
	/* Act */
	TileMap result = executeInstruction(startingMap, rules, itterateRule("rule"));

	/* Assert */
	return result in expectedResults;
}

private test bool executeRuleSingleResult()
{
	/* Arrange */
	RuleMap rules = ("rule" : rule(reflections(false,false,false),[[1]],[[[2]]]));
	TileMap startingMap = [[1, 1], [1, 1]];
	TileMap expectedResult = [[2, 2], [2, 2]];
	int itterations = 4;
	
	/* Act */
	TileMap result = 
		executeInstruction(startingMap, rules, executeRule("rule", itterations));
	
	/* Assert */
	return expectedResult == result;
}

private test bool executeRuleMultipleResults()
{
	/* Arrange */
	RuleMap rules = ("rule" : rule(reflections(false,false,false),[[1]],[[[2]]]));
	TileMap startingMap = [[1, 1], [1, 1]];
	list[TileMap] expectedResults = [[[1, 2], [2, 2]],
																	 [[2, 1], [2, 2]],
																	 [[2, 2], [1, 2]],
																	 [[2, 2], [2, 1]]];
	int itterations = 3;
	
	/* Act */
	TileMap result = 
		executeInstruction(startingMap, rules, executeRule("rule", itterations));

	/* Assert */
	return result in expectedResults;
}