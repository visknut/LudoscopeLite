module utility::TileMap

import List;
import parsing::DataStructures;

data Transformations =
	transformations(bool horizontal, bool vertical, int rotated);

public list[list[str]] createTileMap(str symbol, int width, int height)
{
	return [[symbol | int i <- [0 .. width]] | int j <- [0 .. height]];
}

public TileMap applyTransformation
(
	Transformations transformations,
	TileMap tileMap
)
{
	if (transformations.horizontal)
	{
		tileMap = mirrorHorizontal(tileMap);
	}
	
	if (transformations.vertical)
	{
	 tileMap = mirrorVertical(tileMap);
	}
	
	for (int i <- [0 .. transformations.rotated])
	{
		tileMap = rotateCounterClockwise(tileMap);
	}
	
	return tileMap;
}

public TileMap rotateCounterClockwise(TileMap tileMap)
{
	TileMap rotation = [];
	for (int i <- reverse([0 .. size(head(tileMap))]))
	{
		list[str] newRow = [];
		for (list[str] row <- tileMap)
		{
			newRow += row[i];
		}
		rotation += [newRow];
	}
	return rotation;
}

public TileMap mirrorHorizontal(TileMap tileMap)
{
	return [reverse(row) | list[str] row <- tileMap];
}

public TileMap mirrorVertical(TileMap tileMap)
{
	return reverse(tileMap);
}