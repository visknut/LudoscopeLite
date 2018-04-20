module instructions::Matching

import IO;
import List;
import parsing::DataStructures;
	
public list[Coordinates] findPatternInGrid(TileMap grid, TileMap pattern)
{
	list[Coordinates] matches = [];
	int patternWidth = size(pattern[0]);
	int patternHeight = size(pattern);
	
	int gridWidth = size(grid[0]);
	int gridHeight = size(grid);
	
	list[int] patternFirstLine = pattern[0];
	
	for (/list[list[int]] m:[C*, [A*, patternFirstLine, B*], D*] := grid)
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