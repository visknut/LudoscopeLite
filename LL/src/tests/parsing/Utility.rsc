//////////////////////////////////////////////////////////////////////////////
//
// Utility functions
// @brief        This file contains functions that are needed to test parsing.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         24-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::parsing::Utility

import IO;
import List;
import errors::Parsing;
import parsing::Parser;
import parsing::DataStructures;

public bool checkErrors(SyntaxTree syntaxTree)
{
	for (ParsingError error <- syntaxTree.errors)
	{
		println(errorToString(error));
	}
	return (size(syntaxTree.errors) == 0);
}

public bool checkErrors(TransformationArtifact artifact)
{
	for (ParsingError error <- artifact.errors)
	{
		println(errorToString(error));
	}
	return (size(artifact.errors) == 0);
}