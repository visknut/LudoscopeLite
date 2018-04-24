//////////////////////////////////////////////////////////////////////////////
//
// Interface for parsing
// @brief        Interface for parsing and transforming LL projects.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         23-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::Interface

import parsing::Parser;
import parsing::DataStructures;
import parsing::transformations::TransformSyntaxTree;

public TransformationArtifact parseAndTransform(loc projectFile)
{
	SyntaxTree syntaxTree = parseCompleteProject(projectFile);
	return transformSyntaxTree(syntaxTree);
}