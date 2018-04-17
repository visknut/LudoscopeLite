//////////////////////////////////////////////////////////////////////////////
//
// Transfer recipe files
// @brief        This file contains functions that transfers the data from the
//							 The AST to the data structures.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         17-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::fromAstToData::Recipe

import IO;
import Exception;
import parsing::languages::recipe::AST;
import parsing::DataStructures;
import util::string;


public list[Instruction] parseRecipe(
	str fileName, 
	ProjectInformation projectInfo)
{
	list[Instruction] recipe = [];
	loc recipeFile = fileLocation(projectInfo.projectFile, fileName, ".rcp");
		
	if (exists(recipeFile))
	{
		parsing::languages::recipe::AST::Recipe abstractRecipe 
			= parseRecipeToAST(recipeFile);
		for (parsing::languages::recipe::AST::Instruction instruction 
			<- abstractRecipe.instructions)
		{
			if (!instruction.commented)
			{
				recipe += [parseInstruction(instruction)];
			}
		}
	}
	else
	{
		println("Error: defined file does not exist");
		throw(PathNotFound(recipeFile));
	}
	
	return recipe;
}

private Instruction parseInstruction(iterateRule(bool commented, str ruleName))
{
	return itterateRule(removeQuotes(ruleName));
}

private Instruction parseInstruction(executeRule(bool commented, str ruleName, int executions))
{
	return executeRule(removeQuotes(ruleName), executions);
}