module instructions::Recipe

import instructions::Instructions;
import parsing::DataStructures;

public TileMap executeRecipe(TileMap tileMap, Recipe recipe)
{
	for (Instruction instruction <- recipe)
	{
		tileMap = executeInstruction(instruction);
	}
	return tileMap;
}