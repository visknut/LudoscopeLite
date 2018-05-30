//////////////////////////////////////////////////////////////////////////////
//
// Interface for parsing
// @brief        Interface for parsing and transforming LL projects.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         23-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::Interface

import List;
import parsing::Parser;
import parsing::DataStructures;
import parsing::transformations::TransformSyntaxTree;
import parsing::check::Interface;

public TransformationArtifact parseAndTransform(loc projectFile)
{
	TransformationArtifact artifact = transformationArtifact(undefinedProject(), []);
	SyntaxTree syntaxTree = parseCompleteProject(projectFile);
	syntaxTree = checkSyntaxTree(syntaxTree);
	
	if (size(syntaxTree.errors) == 0)
	{
		artifact = transformSyntaxTree(syntaxTree);
		artifact = checkTransformationArtifact(artifact);
	}
	else
	{
		artifact.errors = syntaxTree.errors;
	}

	return artifact;
}