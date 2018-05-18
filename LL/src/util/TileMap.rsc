module util::TileMap

import List;
import parsing::DataStructures;

public list[TileMap] gatherLeftHands(Reflections reflections, TileMap leftHand)
{
	list[TileMap] leftHands = [leftHand];
	if (reflections.mirrorHorizontal)
	{
		leftHands += [mirrorVertical(leftHand)];
	}
	if (reflections.mirrorVertical)
	{
		leftHands += [mirrorHorizontal(leftHand)];
	}
	if (reflections.rotate)
	{
		leftHands += getAllRotations(leftHand);
	}
	return leftHands;
}

public list[TileMap] getAllRotations(TileMap tileMap)
{
	list[TileMap] rotations = [rotateCounterClockwise(tileMap)];
	
	for (int i <- [0 .. 2])
	{
		rotations += [rotateCounterClockwise(last(rotations))];
	}
	
	return rotations;
}

public TileMap rotateCounterClockwise(TileMap tileMap)
{
	TileMap rotation = [];
	for (int i <- reverse([0 .. size(head(tileMap))]))
	{
		list[int] newRow = [];
		for (list[int] row <- tileMap)
		{
			newRow += row[i];
		}
		rotation += [newRow];
	}
	return rotation;
}

public TileMap mirrorHorizontal(TileMap tileMap)
{
	return [reverse(row) | list[int] row <- tileMap];
}

public TileMap mirrorVertical(TileMap tileMap)
{
	return reverse(tileMap);
}