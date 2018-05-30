module analysis::lplWrapper::PropertyHistory

import IO;
import List;
import util::TileMap;
import parsing::DataStructures;
import execution::DataStructures;
import execution::history::DataStructures;

import lpl::PropertyValidation;
import lpl::DataStructures;
import lpl::language::AST;
	
//////////////////////////////////////////////////////////////////////////////
// Initialize property report.
//////////////////////////////////////////////////////////////////////////////

public PropertyReport initializeReport
(
	int width,
	int height,
	LevelSpecification specification
)
{
	ExtendedTileMaps maps =	generateSartingMaps(width, height);
	PropertyStates propertyStates = 
		[false | Property property <- specification.properties];
	
	return propertyReport(specification, [reportState(maps, propertyStates)]);
}

/* "all" is used in the history, so LPL can use a filter that matches every tile. */
public ExtendedTileMaps generateSartingMaps
(
	int width,
	int height
)
{
	Map currentSymbolMap = createTileMap(ALL, width, height);
	Map currentRuleMap = createTileMap(ALL, width, height);
	return extendedTileMaps(currentSymbolMap, currentRuleMap);
}

//////////////////////////////////////////////////////////////////////////////
// Update report.
//////////////////////////////////////////////////////////////////////////////

public PropertyReport updatePropertyReport(ExecutionArtifact artifact)
{
	ExtendedTileMaps maps = extractExtendedTileMaps(artifact);
	PropertyStates propertyStates = 
		[checkProperty(property, artifact.propertyReport.history, maps) 
		| Property property <- artifact.propertyReport.specification.properties];
	artifact.propertyReport.history + [reportState(maps, propertyStates)];
	PropertyReport updatedReport = artifact.propertyReport;
	return updatedReport;
}

public ExtendedTileMaps extractExtendedTileMaps
(
	ExecutionArtifact artifact
)
{
	/* Retrieve information from the generation history. */
	ModuleExecution history = artifact.history[0];
	str ruleName = history.instructions[0].rules[0].name;
	ReportState previousState = last(artifact.propertyReport.history);
	Map previousSymbolMap = previousState.mapStates.tileMap;

	/* Generate maps for the current state. */
	Map currentSymbolMap = artifact.currentState;
	Map currentRuleMap = updateMap(previousState.mapStates.ruleMap,
																		previousSymbolMap,
																		currentSymbolMap,
																		ruleName);
	return extendedTileMaps(currentSymbolMap, currentRuleMap);
}

private Map updateMap
(
	Map toBeUpdated, 
	Map previousState,
	Map currentState,
	str structureName
)
{
	for (int y <- [0 .. size(previousState)])
	{
		for (int x <- [0 .. size(previousState)])
		{
			if (previousState[y][x] != currentState[y][x])
			{
				toBeUpdated[y][x] = structureName;
			}
		}
	}
	return toBeUpdated;
}