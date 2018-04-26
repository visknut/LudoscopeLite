//////////////////////////////////////////////////////////////////////////////
//
// Function for matching pattern in a grid.
// @brief        This file contains the function for matching pattern 
//							 in a grid.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         20-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module instructions::Matching

import IO;
import List;
import parsing::DataStructures;

// TODO: try different approach (for example: generate permutations and compair to pattern).
public list[Coordinates] findPatternInGrid(TileMap grid, TileMap pattern)
{
	list[Coordinates] matches = [];
	int patternWidth = size(pattern[0]);
	int patternHeight = size(pattern);
	int gridHeight = size(grid);
	list[int] patternFirstLine = pattern[0];
	
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