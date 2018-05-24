module analysis::lplWrapper::PropertyHistory

import IO;
import List;
import util::TileMap;
import parsing::DataStructures;
import execution::DataStructures;
import execution::history::DataStructures;

import lpl::PropertyValidation;
import lpl::DataStructures;
	
//////////////////////////////////////////////////////////////////////////////
// Initialize property report.
//////////////////////////////////////////////////////////////////////////////

public list[ReportState] initializeReport
(
	int width,
	int height,
	list[Property] properties
)
{
	ExtendedTileMaps maps =	generateSartingMaps(width, height);
	PropertyStates propertyStates = 
		[false | Property property <- properties];
	
	return [reportState(maps, propertyStates)];
}

/* -1 is used in the history, so LPL can use a filter that matches every tile. */
public ExtendedTileMaps generateSartingMaps
(
	int width,
	int height
)
{
	KileMap currentSymbolMap = createTileMap(-1, width, height);
	KileMap currentModuleMap = createTileMap(-1, width, height);
	KileMap currentRuleMap = createTileMap(-1, width, height);
	return extendedTileMaps(currentModuleMap, currentRuleMap, currentSymbolMap);
}

//////////////////////////////////////////////////////////////////////////////
// Update report.
//////////////////////////////////////////////////////////////////////////////

public list[ReportState] updatePropertyReport(ExecutionArtifact artifact)
{
	ExtendedTileMaps maps = extractExtendedTileMaps(artifact);
	PropertyStates propertyStates = 
		[checkProperty(property, artifact.propertyReport.history, maps) 
		| Property property <- artifact.propertyReport.properties];
	return [reportState(maps, propertyStates)];
}

public ExtendedTileMaps extractExtendedTileMaps
(
	ExecutionArtifact artifact
)
{
	/* Retrieve information from the generation history. */
	ModuleExecution history = artifact.history[0];
	int moduleIndex = history.nameIndex;
	int ruleIndex = history.instructions[0].rules[0].nameIndex;
	ReportState previousState = last(artifact.propertyReport.history);
	KileMap previousSymbolMap = previousState.mapState.tileIndex;

	/* Generate maps for the current state. */
	KileMap currentSymbolMap = artifact.currentState;
	KileMap currentModuleMap = updateMap(previousState.mapState.moduleIndex,
																			previousSymbolMap,
																			currentSymbolMap,
																			moduleIndex);
	KileMap currentRuleMap = updateMap(previousState.mapState.ruleIndex,
																		previousSymbolMap,
																		currentSymbolMap,
																		ruleIndex);												
	return extendedTileMaps(currentModuleMap, currentRuleMap, currentSymbolMap);
}

private KileMap updateMap
(
	KileMap toBeUpdated, 
	KileMap previousState,
	KileMap currentState,
	int structureIndex
)
{
	for (int y <- [0 .. size(previousState)])
	{
		for (int x <- [0 .. size(previousState)])
		{
			if (previousState[y][x] != currentState[y][x])
			{
				toBeUpdated[y][x] = structureIndex;
			}
		}
	}
	return toBeUpdated;
}