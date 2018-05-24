module experiments::dungeon::execution

import IO;
import List;
import execution::Execution;
import execution::DataStructures;
import parsing::Interface;
import parsing::DataStructures;

import errors::Parsing;

public test bool parseAndExecuteDungeon()
{
	loc projectFile = |project://LL/src/tests/correctTestData/dungeon/dungeon.lsp|;
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
			int i = 0;
			for (a <- newArtifact.propertyReport.history)
			{
				println("\na<i>:");
				iprintln(a.mapState.tileIndex);
				iprintln(a.propertyStates);
				i += 1;
			}
			return true;
		}
	}
	return false;
}

public test bool parseAndExecuteDungeonVar1()
{
	loc projectFile = |project://LL/src/tests/correctTestData/dungeon/dungeon.lsp|;
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
			int i = 0;
			for (a <- newArtifact.propertyReport.history)
			{
				println("\na<i>:");
				iprintln(a.mapState.tileIndex);
				iprintln(a.propertyStates);
				i += 1;
			}
			return true;
		}
	}
	return false;
}

public test bool parseAndExecuteDungeonVar2()
{
	loc projectFile = |project://LL/src/tests/correctTestData/dungeon/dungeon.lsp|;
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
			int i = 0;
			for (a <- newArtifact.propertyReport.history)
			{
				println("\na<i>:");
				iprintln(a.mapState.tileIndex);
				iprintln(a.propertyStates);
				i += 1;
			}
			return true;
		}
	}
	return false;
}

public test bool parseAndExecuteDungeonVar3()
{
	loc projectFile = |project://LL/src/tests/correctTestData/dungeon/dungeon.lsp|;
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
			int i = 0;
			for (a <- newArtifact.propertyReport.history)
			{
				println("\na<i>:");
				iprintln(a.mapState.tileIndex);
				iprintln(a.propertyStates);
				i += 1;
			}
			return true;
		}
	}
	return false;
}

public TransformationArtifact parseAndCheckForErrors(loc projectFile)
{
	TransformationArtifact artifact = parseAndTransform(projectFile);
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