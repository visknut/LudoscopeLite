module parsing::Interface

import parsing::Parser;
import parsing::DataStructures;
import parsing::CreateSyntaxTree;
import parsing::transformations::TransformSyntaxTree;

public TransformationArtifact parseAndTransform(loc projectFile)
{
	SyntaxTree syntaxTree = parseCompleteProject(projectFile);
	return transformSyntaxTree(syntaxTree);
}