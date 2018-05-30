//////////////////////////////////////////////////////////////////////////////
//
// Transform Alphabet
// @brief        Functions that move the relevant content from the AST to
//							 a new ADT declared in DataStructures.rsc.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         23-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::transformations::Recipe

import parsing::Parser;
import parsing::DataStructures;
import parsing::transformations::Utility;
import parsing::transformations::Instruction;
import parsing::languages::recipe::AST;

public TransformationArtifact transformRecipes(TransformationArtifact artifact, 
	SyntaxTree syntaxTree)
{
	for (str recipeName <- syntaxTree.recipes)
	{
		int moduleIndex = findModuleIndex(recipeName, artifact);
		
		for (AbstractInstruction instruction 
			<- syntaxTree.recipes[recipeName].instructions)
		{
			if (!instruction.commented)
			{
				artifact.project.modules[moduleIndex].recipe += 
					[parseInstruction(artifact, instruction)];
			}
		}
	}
	return artifact;
}

public TransformationArtifact addEmptyRecipes(TransformationArtifact artifact)
{
	artifact = visit(artifact)
	{
		case ludoscopeModule(name, inputs,	alphabetName,	startingState, rules, []) =>
			ludoscopeModule(name, inputs,	alphabetName,	startingState, rules, [executeGrammar()])
	}
	return artifact;
}