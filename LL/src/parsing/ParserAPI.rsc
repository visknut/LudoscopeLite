//////////////////////////////////////////////////////////////////////////////
//
// Parser for LL projects
// @brief        This file contains the public interface for parsing
//							 a Ludoscope project.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         17-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::ParserAPI

import IO;
import List;
import parsing::fromAstToData::Project;
import parsing::DataStructures;
import errors::Parsing;

public void parseAndPrint(loc projectFile)
{
	ParsingArtifact artifact = parseProject(projectFile);
	if (size(artifact.environment.errors) > 0)
	{
		for (ParsingError error <- artifact.environment.errors)
		{
			println(errorToString(error));
		}
	}
	else
	{
		println(artifact.project);
	}
}