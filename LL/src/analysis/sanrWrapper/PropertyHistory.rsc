module analysis::sanrWrapper::PropertyHistory

import List;
import utility::TileMap;
import parsing::DataStructures;
import execution::DataStructures;
import execution::history::DataStructures;

import sanr::PropertyValidation;
import sanr::DataStructures;
import sanr::language::AST;
	
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

/* 'ALL' is used in the history, so SAnR can use a filter that matches every tile. */
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
		[checkProperty(property, artifact.propertyReport.history, maps.tileMap)
		| Property property <- artifact.propertyReport.specification.properties];
	artifact.propertyReport.history += [reportState(maps, propertyStates)];
	return artifact.propertyReport;
}

public ExtendedTileMaps extractExtendedTileMaps
(
	ExecutionArtifact artifact
)
{
	/* Retrieve information from the generation history. */
	Step step = artifact.history[0];
	str ruleName = step.ruleName;
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
		for (int x <- [0 .. size(previousState[0])])
		{
			if (previousState[y][x] != currentState[y][x])
			{
				toBeUpdated[y][x] = structureName;
			}
		}
	}
	return toBeUpdated;
}