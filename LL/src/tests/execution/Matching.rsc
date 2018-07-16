//////////////////////////////////////////////////////////////////////////////
//
// Tests for pattern matching
// @brief        This file contains all tests for for pattern matching.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         20-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::execution::Matching

import IO;
import execution::instructions::Matching;
import parsing::DataStructures;
import utility::TileMap;

public bool runAllTests()
{
	return findPatternInGridSingleMatch()
	&& findPatternInGridDouble()
	&& matchHorizontalMirror()
	&& matchVerticalMirror()
	&& matchSingleRotation()
	&& matchNoDuplicates();
}

private test bool findPatternInGridSingleMatch()
{
	/* Arrange */
	TileMap pattern = [["1"],
										 ["1"],
										 ["1"]];
	TileMap grid = [["1", "0", "0"], 
									["1", "0", "0"], 
									["1", "0", "0"]];
	list[Coordinates] expectedResult = [coordinates(0, 0)];
	
	/* Act */
	list[Coordinates] result = findPatternInGrid(grid, pattern);
	
	/* Assert */
	return expectedResult == result;
}

private test bool findPatternInGridDouble()
{
	/* Arrange */
	TileMap pattern = [["1"],
										 ["1"],
										 ["1"]];
	TileMap grid = [["1", "0", "1"], 
									["1", "0", "1"], 
									["1", "0", "1"]];
	list[Coordinates] expectedResult = [coordinates(0, 0), coordinates(2, 0)];
	
	/* Act */
	list[Coordinates] result = findPatternInGrid(grid, pattern);
	
	/* Assert */
	return expectedResult == result;
}

private test bool matchHorizontalMirror()
{
	/* Arrange */
	Reflections reflections = reflections(true, false, false);
	TileMap leftHand = [["3", "2", "1"]];
	Rule rule = rule(reflections, leftHand, []);
	TileMap grid = [["1", "2", "3"], 
									["0", "0", "0"], 
									["0", "0", "0"]];
	lrel[Coordinates, Transformations] expectedResult = 
		[<coordinates(0, 0), transformations(true, false, 0)>];
	
	/* Act */
	lrel[Coordinates, Transformations] result = 
		findPatternWithTransformations(grid, rule);
	
	/* Assert */
	return expectedResult == result;
}

private test bool matchVerticalMirror()
{
	/* Arrange */
	Reflections reflections = reflections(false, true, false);
	TileMap leftHand = [["3"],
											["2"],
											["1"]];
	Rule rule = rule(reflections, leftHand, []);
	TileMap grid = [["1", "0", "0"], 
									["2", "0", "0"], 
									["3", "0", "0"]];
	lrel[Coordinates, Transformations] expectedResult = 
		[<coordinates(0, 0), transformations(true, false, 2)>];
	
	/* Act */
	lrel[Coordinates, Transformations] result = 
		findPatternWithTransformations(grid, rule);
	
	/* Assert */
	return expectedResult == result;
}

private test bool matchSingleRotation()
{
	/* Arrange */
	Reflections reflections = reflections(false, false, true);
	TileMap leftHand = [["1"],
											["0"],
											["2"]];
	Rule rule = rule(reflections, leftHand, []);
	TileMap grid = [["1", "0", "2"], 
									["0", "0", "0"], 
									["0", "0", "0"]];
	lrel[Coordinates, Transformations] expectedResult = 
		[<coordinates(0, 0), transformations(false, false, 1)>];
	
	/* Act */
	lrel[Coordinates, Transformations] result = 
		findPatternWithTransformations(grid, rule);
	
	/* Assert */
	return expectedResult == result;
}

private test bool matchNoDuplicates()
{
	/* Arrange */
	Reflections reflections = reflections(true, true, true);
	TileMap leftHand = [["1"],
											["0"],
											["2"]];
	Rule rule = rule(reflections, leftHand, []);
	TileMap grid = [["1", "0", "2"], 
									["0", "0", "0"], 
									["0", "0", "0"]];
	lrel[Coordinates, Transformations] expectedResult = 
		[<coordinates(0, 0), transformations(false, false, 1)>,
		 <coordinates(0, 0), transformations(true, false, 1)>];
	
	/* Act */
	lrel[Coordinates, Transformations] result = 
		findPatternWithTransformations(grid, rule);

	/* Assert */
	return expectedResult == result;
}