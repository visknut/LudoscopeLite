module tests::instructions::Matching

import instructions::Matching;
import parsing::DataStructures;

public bool runAllTests()
{
	return singleMatchInSmallGrid()
	&& doubleMatchInSmallGrid();
}

private test bool singleMatchInSmallGrid()
{
	/* Arrange */
	TileMap pattern = [[1],[1],[1]];
	TileMap grid = [[1, 0, 0], [1, 0, 0], [1, 0, 0]];
	list[Coordinates] expectedResult = [coordinates(0, 0)];
	
	/* Act */
	list[Coordinates] result = findPatternInGrid(grid, pattern);
	
	/* Assert */
	return expectedResult == result;
}

private test bool doubleMatchInSmallGrid()
{
	/* Arrange */
	TileMap pattern = [[1],[1],[1]];
	TileMap grid = [[1, 0, 1], [1, 0, 1], [1, 0, 1]];
	list[Coordinates] expectedResult = [coordinates(0, 0), coordinates(2, 0)];
	
	/* Act */
	list[Coordinates] result = findPatternInGrid(grid, pattern);
	
	/* Assert */
	return expectedResult == result;
}