//////////////////////////////////////////////////////////////////////////////
//
// Transform AST
// @brief        Functions that move the relevant content from the AST to
//							 a new ADT declared in DataStructures.rsc.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         23-04-2018
//
//////////////////////////////////////////////////////////////////////////////

// TODO: put transformations in seprate files.
module parsing::transformations::CompleteSyntaxTree

import parsing::Parser;
import parsing::DataStructures;

import parsing::transformations::TransformInstructions;
import parsing::transformations::Project;
import parsing::transformations::Alphabet;
import parsing::transformations::Grammar;
import parsing::transformations::Recipe;
import parsing::transformations::Properties;

import lpl::language::AST;

public TransformationArtifact transformSyntaxTree(SyntaxTree syntaxTree)
{
	LudoscopeProject project = ludoscopeProject([], (), specification([]));
	TransformationArtifact artifact = transformationArtifact(project, []);
	
	artifact = transformProject(artifact, syntaxTree);
	artifact = transformAplhabets(artifact, syntaxTree);
	artifact = transformGrammars(artifact, syntaxTree);
	artifact = transformRecipes(artifact, syntaxTree);
	artifact = transformProperties(artifact, syntaxTree);
	
	artifact = addEmptyRecipes(artifact);
	
	return artifact;
}
