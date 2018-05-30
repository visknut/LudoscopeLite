//////////////////////////////////////////////////////////////////////////////
//
// Check Interface
// @brief        Interface for all checks on the synstax tree and transformed
//							 syntax tree.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         28-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::check::Interface

import parsing::Parser;
import parsing::DataStructures;

import parsing::check::Version;
import parsing::check::Maps;
import parsing::check::Names;

public SyntaxTree checkSyntaxTree(SyntaxTree syntaxTree)
{
	syntaxTree = checkVersion(syntaxTree);
	syntaxTree = checkMapTypes(syntaxTree);
	return syntaxTree;
}

public TransformationArtifact checkTransformationArtifact
(
	TransformationArtifact artifact
)
{
	artifact = checkPropertyNames(artifact);
	return artifact;
}