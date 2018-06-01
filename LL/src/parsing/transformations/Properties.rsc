//////////////////////////////////////////////////////////////////////////////
//
// Transform properties
// @brief        Functions that move the relevant content from the AST to
//							 a new ADT declared in DataStructures.rsc.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         23-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::transformations::Properties

import parsing::Parser;
import parsing::DataStructures;
import sanr::language::AST;

public TransformationArtifact transformProperties
(
	TransformationArtifact artifact, 
	SyntaxTree syntaxTree
)
{
	visit(syntaxTree)
	{
		case LevelSpecification specification:
		{
			artifact.project.specification = specification;
		}
	}
	return artifact;
}
