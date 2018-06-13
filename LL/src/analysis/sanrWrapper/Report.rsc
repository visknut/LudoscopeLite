module analysis::sanrWrapper::Report

import IO;
import List;
import Map;
import execution::Execution;
import execution::DataStructures;
import parsing::Interface;
import parsing::DataStructures;

import sanr::DataStructures;
import sanr::language::AST;

import errors::Parsing;

public loc projectFile = |project://LL/src/tests/correctTestData/dungeon/dungeon.lsp|;
public loc projectFileVar1 = |project://LL/src/tests/correctTestData/dungeonVar1/dungeon.lsp|;
public loc projectFileVar2 = |project://LL/src/tests/correctTestData/dungeonVar2/dungeon.lsp|;


//data sanrBugReport =
data Bug
	=	bug(str rule, Property property);
	
alias OutputCount = map[TileMap, int];
alias ReportCount	= map[list[ReportState], int];
alias	PropertyCount = map[int, int];
alias	BugCount = map[Bug, int];

public void executeMultipleTimes(loc projectFile, int n)
{
	map[TileMap, int] outputCount = ();
	map[list[ReportState], int] reportCount = ();
	map[PropertyStates, int] propertyStatesCount = ();
	map[int, int] propertyCount = ();
	map[Bug, int] bugCount = ();
	
	for (int i <- [0 .. n])
	{
		ExecutionArtifact artifact = parseAndExecuteFile(projectFile);
		outputCount[artifact.currentState] ? 0 += 1;
		reportCount[artifact.propertyReport.history] ? 0 += 1;
		propertyStatesCount[last(artifact.propertyReport.history).propertyStates] ? 0 += 1;
		
		for (int i <- [0 .. size(last(artifact.propertyReport.history).propertyStates)])
		{
			if (!last(artifact.propertyReport.history).propertyStates[i])
			{
				propertyCount[i] ? 0 += 1;
			}
		}
		
		for (Bug bug <- findBugs(artifact))
		{
			bugCount[bug] ? 0 += 1;
		}
	}
	
	println("Number of unique executions: <size(reportCount)>");
	println("Number of unique outputs: <size(outputCount)>");
	println("Number of unique property end states: <size(propertyStatesCount)>");
	println("Number of bad maps: <size(outputCount) - (propertyStatesCount[[true, true, true, true, true]] ? 0 )>");
	println("Number of broken properties: <size(propertyCount)>");
	println("Number of bugs: <size(bugCount)>");
	iprintln(bugCount);
}

public list[Bug] findBugs(ExecutionArtifact artifact)
{
	list[ReportState] history = artifact.propertyReport.history;
	list[Bug] bugs = [];
	for (int i <- [0 .. size(last(history).propertyStates)])
	{
		if (!last(history).propertyStates[i])
		{
			bugs += bug(getRule(i, artifact), artifact.propertyReport.specification.properties[i]);
		}
	}

	return bugs;
}

public str getRule(int property, ExecutionArtifact artifact)
{
	list[ReportState] history = artifact.propertyReport.history;
	int steps = size(history);
	int problematicStep = -1;
	for (int i <- [steps-1 .. -1])
	{
		//println("STEP: <i>, PROPERTY: <history[i].propertyStates[property]>");
		if (history[i].propertyStates[property])
		{
			problematicStep = i;
			break;
		}
	}
	
	if (problematicStep != -1)
	{
		//println("STEP: <problematicStep>");
		//println("Property: <property>");
		int i = 0;
		visit(artifact.history)
		{
			case ruleExecution(str name, int rightHandIndex, Coordinates location) :
			{
				//println(ruleExecution(nameIndex, rightHandIndex, location));
				if (i == problematicStep)
				{
					return name;
				}
				i += 1;
			}
		}
	}
	return -1;
}

public ExecutionArtifact parseAndExecuteFile(loc projectFile)
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
				throw(Timeout());
			}
		}
		else
		{
			//int i = 0;
			//for (a <- newArtifact.propertyReport.history)
			//{
			//	println("\na<i>:");
			//	iprintln(a.mapState.tileIndex);
			//	iprintln(a.propertyStates);
			//	i += 1;
			//}
			return newArtifact;
		}
	}
	return newArtifact;
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
			throw(Timeout());
		}
	}
	return artifact;
}