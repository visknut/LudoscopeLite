module execution::lpl::PropertyHistory

import List;
import util::TileMap;
import parsing::DataStructures;
import execution::DataStructures;
import execution::history::DataStructures;
	
alias PropertyStates = list[bool];

// Generate a PropertyMap for each step in the history.
// Check every property for each propertyMap.

public PropertyHistory getPropertyState(ExecutionArtifact artifact)
{
	StepInfo stepInfo = extractStepInfo(artifact.history[0]);
	ExtendedTileMaps maps = extractExtendedTileMaps(stepInfo, artifact);
	PropertyStates propertyStates = 
		[checkProperty(property, artifact.propertyReport.history, maps) 
		| Property property <- artifact.propertyReport.properties];
	
	artifact.propertyReport.history += [<stepInfo, maps, propertyStates>];
	return artifact.propertyReport.history;
}

public ExtendedTileMaps extractExtendedTileMaps
(
	StepInfo currentStep, 
	ExecutionArtifact artifact
)
{
	TileMap currentSymbolMap = artifact.currentState;
	if (size(artifact.propertyReport.history) > 0)
	{
		PropertyHistory previousState = [last(artifact.propertyReport.history)];
			
		TileMap previousSymbolMap = previousState[0].mapState.tileIndex;
		TileMap currentModuleMap = updateMap(previousState[0].mapState.moduleIndex,
																				previousSymbolMap,
																				currentSymbolMap,
																				currentStep.moduleIndex);
		TileMap currentRuleMap = updateMap(previousState[0].mapState.ruleIndex,
																			previousSymbolMap,
																			currentSymbolMap,
																			currentStep.ruleIndex);
		return extendedTileMaps(currentModuleMap, currentRuleMap, currentSymbolMap);
	}
	else
	{
		int width = size(currentSymbolMap[0]);
		int height = size(currentSymbolMap);
		TileMap currentModuleMap = createTileMap(currentStep.moduleIndex, width, height);
		TileMap currentRuleMap = createTileMap(currentStep.ruleIndex, width, height);
		return extendedTileMaps(currentModuleMap, currentRuleMap, currentSymbolMap);
	}
}

private TileMap updateMap
(
	TileMap toBeUpdated, 
	TileMap previousState,
	TileMap currentState,
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

public StepInfo extractStepInfo(ModuleExecution history)
{
	int moduleIndex = history.nameIndex;
	int recipeStep = size(history.instructions) - 1;
	int ruleIndex = history.instructions[0].rules[0].nameIndex;
	Coordinates matchLocation = history.instructions[0].rules[0].location;
	int rightHandIndex = history.instructions[0].rules[0].rightHandIndex;
	StepInfo stepInfo = 
		stepInfo(moduleIndex, recipeStep,  ruleIndex, matchLocation, rightHandIndex);
	return stepInfo;
}