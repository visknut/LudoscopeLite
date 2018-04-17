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
import errors::Parsing;


public ParsingArtifact parseRecipe(ParsingArtifact artifact, str fileName)
{
	loc recipeFile = fileLocation(artifact.environment.projectFile, fileName, ".rcp");
		
	if (exists(recipeFile))
	{
		/* Try parsing the recipe file and catch any errors thrown. */
		try 
		{
			parsing::languages::recipe::AST::Recipe abstractRecipe 
				= parseRecipeToAST(recipeFile);
			/* Transfer parsed recipe to the new data structure. */
			for (parsing::languages::recipe::AST::Instruction instruction 
				<- abstractRecipe.instructions)
			{
				if (!instruction.commented)
				{
					artifact.environment.newModule.recipe += 
						[parseInstruction(instruction)];
				}
			}
		}
		catch ParseError(loc errorLocation):
		{
			artifact.environment.errors += [errors::Parsing::parsing(errorLocation)];
		}
		catch Ambiguity(loc errorLocation, str usedSyntax, str parsedText):
		{
			artifact.environment.errors += 
				[errors::Parsing::ambiguity(errorLocation, usedSyntax)];
		}
		catch IllegalArgument(value v, str message):
		{
			artifact.environment.errors += [errors::Parsing::imploding(recipeFile)];
		}
	}
	else
	{
		artifact.environment.errors += [errors::Parsing::fileNotFound(recipeFile)];
	}
	
	return artifact;
}

private Instruction parseInstruction(iterateRule(bool commented, str ruleName))
{
	return itterateRule(removeQuotes(ruleName));
}

private Instruction parseInstruction(executeRule(bool commented, str ruleName, int executions))
{
	return executeRule(removeQuotes(ruleName), executions);
}