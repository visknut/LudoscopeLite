//////////////////////////////////////////////////////////////////////////////
//
// Function for matching pattern in a grid.
// @brief        This file contains the function for matching pattern 
//							 in a grid.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         20-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module execution::instructions::Matching

import IO;
import List;
import parsing::DataStructures;
import utility::TileMap;
import util::Math;

public lrel[Coordinates, Transformations] findPatternWithTransformations
(
	TileMap tileMap,
	Rule rule
)
{
	lrel[Coordinates, Transformations] matches = [];

	/* Check for all 8 combinations of the three different reflections. */
	TileMap pattern = rule.leftHand;
		matches += [
			<coordinates, transformations(false, false, 0)> 
			| Coordinates coordinates <- findPatternInGrid(tileMap, pattern)
		];
	
	if (rule.reflections.mirrorHorizontal)
	{
		pattern = mirrorHorizontal(rule.leftHand);
		matches += [
			<coordinates, transformations(true, false, 0)> 
			| Coordinates coordinates <- findPatternInGrid(tileMap, pattern)
		];
	}
	
	if (rule.reflections.mirrorVertical)
	{
		pattern = mirrorVertical(rule.leftHand);
		matches += [
			<coordinates, transformations(false, true, 0)> 
			| Coordinates coordinates <- findPatternInGrid(tileMap, pattern)
		];
	}
	
	if (rule.reflections.rotate)
	{
		pattern = rule.leftHand;
		matches += findRotationsOfPattern(tileMap, pattern, false, false);
	}
	
	if (rule.reflections.mirrorHorizontal && rule.reflections.mirrorVertical)
	{
		pattern = mirrorHorizontal(mirrorVertical(rule.leftHand));
		matches += [
			<coordinates, transformations(true, true, 0)> 
			| Coordinates coordinates <- findPatternInGrid(tileMap, pattern)
		];
	}
	
	if (rule.reflections.rotate && rule.reflections.mirrorHorizontal)
	{
		pattern = mirrorHorizontal(rule.leftHand);
		matches += findRotationsOfPattern(tileMap, pattern, true, false);
	}
	
	if (rule.reflections.mirrorVertical && rule.reflections.rotate)
	{
		pattern = mirrorVertical(rule.leftHand);
		matches += findRotationsOfPattern(tileMap, pattern, false, true);
	}
	
	
	if (rule.reflections.mirrorHorizontal && rule.reflections.mirrorVertical 
		&& rule.reflections.rotate)
	{
		pattern = mirrorHorizontal(mirrorVertical(rule.leftHand));
		matches += findRotationsOfPattern(tileMap, pattern, true, true);
	}
	
	matches = removeDulpicates(matches);
	
	return matches;
}

private lrel[Coordinates, Transformations] removeDulpicates
(
	lrel[Coordinates, Transformations] matches
)
{
	/* Rewrite vertical transformations to 
		a horizontal transformation and 2 rotations. */
	matches = visit(matches)
	{
		case <c, transformations(horizontal, true, rotations)> 
			=> <c, transformations(!horizontal, false, rotations + 2)>
	}
	
	/* Simplify rotations. */
		matches = visit(matches)
	{
		case <c, transformations(horizontal, vertical, rotations)> 
			=> <c, transformations(horizontal, vertical, rotations % 4)>
	}
	
	return dup(matches);
}

private lrel[Coordinates, Transformations] findRotationsOfPattern
(
	TileMap tileMap, 
	TileMap pattern,
	bool mirrorHorizontal,
	bool mirrorVertical
)
{
	lrel[Coordinates, Transformations] matches = [];
	
	/* Check for 270 degrees. */
	pattern = rotateCounterClockwise(pattern);
	matches += [
		<coordinates, 
		transformations(mirrorHorizontal, mirrorVertical, 1)> 
		| Coordinates coordinates <- 
		findPatternInGrid(tileMap, pattern)
	];
	
	/* Check for 180 degrees. */
	pattern = rotateCounterClockwise(pattern);
	matches += [
		<coordinates, 
		transformations(mirrorHorizontal, mirrorVertical, 2)> 
		| Coordinates coordinates <- 
		findPatternInGrid(tileMap, pattern)
	];
	
	/* Check for 90 degrees. */
	pattern = rotateCounterClockwise(pattern);
	matches += [
		<coordinates, 
		transformations(mirrorHorizontal, mirrorVertical, 3)> 
		| Coordinates coordinates <- 
		findPatternInGrid(tileMap, pattern)
	];
		
	return matches;
}

// TODO: Don't collect all the matches. But one random match, by starting 
// The search at a random location on the tile map.
public list[Coordinates] findPatternInGrid(TileMap grid, TileMap pattern)
{
	list[Coordinates] matches = [];
	int patternWidth = size(pattern[0]);
	int patternHeight = size(pattern);
	int gridHeight = size(grid);
	list[str] patternFirstLine = pattern[0];
	
	for (/[C*, [A*, patternFirstLine, B*], D*] := grid)
	{
		int widthOffset = size(A);
		int heightOffset = size(C);
		bool match = true;
		if (heightOffset + patternHeight <= gridHeight)
		{
			for (int row <- [heightOffset + 1 .. heightOffset + patternHeight])
			{
				if (pattern[row - heightOffset] != 
					grid[row][widthOffset .. widthOffset + patternWidth])
				{
					match = false;
					break;
				}
			}
			if (match)
			{
				matches += [coordinates(widthOffset, heightOffset)];
			}
		}
	}
	return matches;
}

public list[Coordinates] findPatternInGrid2(TileMap grid, TileMap pattern)
{
	int patternWidth = size(pattern[0]);
	int patternHeight = size(pattern);
	
	int gridHeight = size(grid);
	int gridWidth = size(grid[0]);
	
	int startX = arbInt(gridWidth);
	int startY = arbInt(gridHeight);
	
	int currentX = startX + 1;
	int currentY = startY + 1;
	
	while (startX != currentX && startY != currentY)
	{

		/* start at the next row. */
		if (currentX >= gridWidth)
		{
			currentX = 0;
			currentY += 1;
		}
		/* Start at the beginning of the grid. */
		if (currentY >= gridHeight)
		{
			currentY = 0;
		}
		
		/* Only check when within bounds. */
		if ((currentX <= gridWidth - patternWidth) 
			&& (currentY <= gridHeight - patternHeight))
		{
			bool match = true;
			for (int x <- [0 .. patternWidth])
			{
				for (int y <- [0 .. patternHeight])
				{
					if (pattern[y][x] != grid[currentY + y][currentX + x])
					{
						match = false;
						break;
					}
				}
				if (!match)
				{
					break;
				}
			}
			
			if (match)
			{
				return [coordinates(currentX, currentY)];
			}
		}
		currentX += 1;
	}
	
	return [];
}