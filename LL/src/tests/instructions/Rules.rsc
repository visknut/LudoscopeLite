module tests::instructions::Rules

import instructions::Rules;
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
	Rule rule = rule(topology(false,false,false),[[1]],[[[2]]]);
	TileMap startingMap = [[0, 0], [1, 0]];
	TileMap expectedResult = [[0, 0], [2, 0]];
	
	/* Act */
	TileMap result = itterateRule(rule, startingMap);
	
	/* Assert */
	return expectedResult == result;
}

private test bool itterateRuleMultipleResults()
{
	/* Arrange */
	Rule rule = rule(topology(false,false,false),[[1]],[[[2]]]);
	TileMap startingMap = [[1, 0], [1, 0]];
	list[TileMap] expectedResults = [[[1, 0], [2, 0]],
																	 [[2, 0], [1, 0]]];
	
	/* Act */
	TileMap result = itterateRule(rule, startingMap);

	/* Assert */
	return result in expectedResults;
}

private test bool executeRuleSingleResult()
{
	/* Arrange */
	Rule rule = rule(topology(false,false,false),[[1]],[[[2]]]);
	TileMap startingMap = [[1, 1], [1, 1]];
	TileMap expectedResult = [[2, 2], [2, 2]];
	int itterations = 4;
	
	/* Act */
	TileMap result = executeRule(rule, itterations, startingMap);
	
	/* Assert */
	return expectedResult == result;
}

private test bool executeRuleMultipleResults()
{
	/* Arrange */
	Rule rule = rule(topology(false,false,false),[[1]],[[[2]]]);
	TileMap startingMap = [[1, 1], [1, 1]];
	list[TileMap] expectedResults = [[[1, 2], [2, 2]],
																	 [[2, 1], [2, 2]],
																	 [[2, 2], [1, 2]],
																	 [[2, 2], [2, 1]]];
	int itterations = 3;
	
	/* Act */
	TileMap result = executeRule(rule, itterations, startingMap);

	/* Assert */
	return result in expectedResults;
}