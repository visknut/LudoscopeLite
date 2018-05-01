module execution::instructions::Recipe

import execution::instructions::Instructions;
import parsing::DataStructures;

public TileMap executeRecipe(TileMap tileMap, RuleMap rules, Recipe recipe)
{
	for (Instruction instruction <- recipe)
	{
		tileMap = executeInstruction(tileMap, rules, instruction);
	}
	return tileMap;
}