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

private loc reportFile = |project://LL/src/ide/output/sanr.output|;
	
alias OutputCount = map[TileMap, int];
alias	BugTypeCount = set[BugType];
alias BugMap = map[BugType, list[Bug]];

data Report
	= report(OutputCount outputs, int brokenOutputs, BugTypeCount bugTypes, BugMap bugs) 
	| emptyReport();
	
data BugType
	= bugType(str rule, Property property) | emptyBugType();

data Bug
	=	bug(str rule, Property property, ExecutionArtifact execution, int executionNumber, int step);

public Report analyseProject(LudoscopeProject project, int itterations)
{
	list[ExecutionArtifact] executions = [];
	OutputCount outputs = ();
	int brokenOutputs = 0;
	BugTypeCount bugTypes = {};
	BugMap bugMap = ();

	for (int i <- [0 .. itterations])
	{
		ExecutionArtifact artifact = executeProject(project);
		executions += artifact;	
		outputs[artifact.currentState] ? 0 += 1;
		
		PropertyStates finalPropertyStates = last(artifact.propertyReport.history).propertyStates;
		if (false in finalPropertyStates)
		{
			brokenOutputs += 1;
		}
		
		for (Bug bug <- findBugs(artifact))
		{
			bug.executionNumber = i;
			BugType bugType = bugType(bug.rule, bug.property);
			bugTypes += bugType;
			if (bugType in bugMap)
			{
				bugMap[bugType] += [bug];
			}
			else
			{
				bugMap += (bugType : [bug]);
			}

		}
	}
	
	return report(outputs, brokenOutputs, bugTypes, bugMap);
}

public list[Bug] findBugs(ExecutionArtifact artifact)
{
	list[ReportState] history = artifact.propertyReport.history;
	list[Bug] bugs = [];
	
	for (int i <- [0 .. size(last(history).propertyStates)])
	{
		if (!last(history).propertyStates[i])
		{
			Property property = artifact.propertyReport.specification.properties[i];
			
			int step = getStep(i, artifact);
			str ruleName = artifact.history[step].ruleName;
			bugs += bug(ruleName, property, artifact, -1, step);
		}
	}

	return bugs;
}

public int getStep(int property, ExecutionArtifact artifact)
{
	list[ReportState] history = artifact.propertyReport.history;
	int steps = size(history);

	for (int i <- [steps-1 .. -1])
	{
		if (history[i].propertyStates[property])
		{
			return i;
		}
	}
	return steps - 1;
}