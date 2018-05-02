//////////////////////////////////////////////////////////////////////////////
//
// Menu Functions
// @brief        This file contains functions that can be used from the IDE.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         02-05-2018
//
//////////////////////////////////////////////////////////////////////////////

module ide::MenuFunctions

import IO;
import ParseTree;
import errors::Parsing;
import String;

import parsing::Interface;
import parsing::DataStructures;

import execution::Execution;
import execution::DataStructures;

public void parseAndTransform(Tree tree, loc projectFile)
{
	TransformationArtifact artifact = parseAndCheckForErrors(projectFile);
	if (artifact.errors == [])
	{
		iprintln(artifact.project);
	}
}

public void executeProject(Tree tree, loc projectFile)
{
	TransformationArtifact artifact = parseAndCheckForErrors(projectFile);
	if (artifact.errors == [])
	{
		ExecutionArtifact newArtifact = executeProject(artifact.project);
		if (newArtifact.errors != [])
		{
			println("There were errors found while parsing the project:");
			for (ParsingError error <- artifact.errors)
			{
				println(errorToString(error));
			}
		}
		else
		{
			iprintln(newArtifact.output);
		}
	}
}

private TransformationArtifact parseAndCheckForErrors(loc projectFile)
{
	TransformationArtifact artifact = parseAndTransform(toLocation(projectFile.uri));
	if (artifact.errors != [])
	{
		println("There were errors found while parsing the project:");
		for (ParsingError error <- artifact.errors)
		{
			println(errorToString(error));
		}
	}
	return artifact;
}