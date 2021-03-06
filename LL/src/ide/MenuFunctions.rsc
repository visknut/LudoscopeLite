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
import DateTime;

import utility::Time;

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

// TODO: extract funtion and use as wrapper.
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
	iprintln(newArtifact);
}

public void executeProjectToFile(Tree tree, loc projectFile)
{
	if (exists(|project://LL/src/ide/output/ide.output|))
	{
		TransformationArtifact artifact = parseAndCheckForErrors(projectFile);
		if (artifact.errors == [])
		{
			ExecutionArtifact newArtifact = executeProject(artifact.project);
			if (newArtifact.errors != [])
			{
				writeFile(|project://LL/src/ide/output/ide.output|, 
					"There were errors found while executing the project:\n");
				for (ParsingError error <- artifact.errors)
				{
					appendToFile(|project://LL/src/ide/output/ide.output|, errorToString(error));
				}
			}
			else
			{
				writeFile(|project://LL/src/ide/output/ide.output|, newArtifact.output);
			}
		} 
		else
		{
		writeFile(|project://LL/src/ide/output/ide.output|, 
					"There were errors found while parsing the project:\n");
		appendToFile(|project://LL/src/ide/output/ide.output|, newArtifact);
		}
		iprintln("Result saved at: |project://LL/src/ide/output/ide.output|");
	}
	else
	{
		iprintln("|project://LL/src/ide/output/ide.output| missing");
	}
}

public void sanrReportToFile(Tree tree, loc projectFile)
{

}

public void timeExecution1x(Tree tree, loc projectFile)
	= timeExecution(tree, projectFile, 1);
	
public void timeExecution100x(Tree tree, loc projectFile)
	= timeExecution(tree, projectFile, 100);
	
public void timeExecution10000x(Tree tree, loc projectFile)
	= timeExecution(tree, projectFile, 10000);

private void timeExecution(Tree tree, loc projectFile, int executions)
{
	Duration totalTime = duration(0, 0, 0, 0, 0, 0, 0);
	TransformationArtifact artifact = parseAndCheckForErrors(projectFile);
	if (artifact.errors != [])
	{
		println("Parsing Error.");
		return;
	}
	
	for (int i <- [0 .. executions])
	{
		datetime startTime = now();
		ExecutionArtifact newArtifact = executeProject(artifact.project);
		datetime postExecutionTime = now();
		if (newArtifact.errors != [])
		{
			println("Execution Error.");
			return;
		}
		datetime endTime = now();
		Duration executionDuration = (endTime - startTime);
		totalTime = addDuration(totalTime, (endTime - startTime));
	}
	totalTime = flattenDuration(totalTime);
	println("Total time: " + durationToString(totalTime));
	str averageTime = "<durationToMilliseconds(totalTime)/executions>ms";
	println("Average time: " + averageTime);
}

public TransformationArtifact parseAndCheckForErrors(loc projectFile)
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