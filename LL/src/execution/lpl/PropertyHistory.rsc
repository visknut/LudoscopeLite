module execution::lpl::PropertyHistory

import IO;
import List;
import util::TileMap;
import parsing::DataStructures;
import execution::DataStructures;
import execution::history::DataStructures;
import execution::lpl::PropertyValidation;
	
alias PropertyStates = list[bool];

public PropertyHistory addStartingState
(
	int width,
	int height,
	list[Property] properties
)
{
	StepInfo stepInfo = stepInfo(-1, -1, -1, <-1, -1>, -1);
	ExtendedTileMaps maps =	generateSartingMaps(width, height);
	PropertyStates propertyStates = 
		[false | Property property <- properties];
	
	return [<stepInfo, maps, propertyStates>];
}


public ExtendedTileMaps generateSartingMaps
(
	int width,
	int height
)
{
	TileMap currentSymbolMap = createTileMap(-1, width, height);
	TileMap currentModuleMap = createTileMap(-1, width, height);
	TileMap currentRuleMap = createTileMap(-1, width, height);
	return extendedTileMaps(currentModuleMap, currentRuleMap, currentSymbolMap);
}

public PropertyHistory getPropertyState(ExecutionArtifact artifact)
{
	StepInfo stepInfo = extractStepInfo(artifact.history[0]);
	ExtendedTileMaps maps = extractExtendedTileMaps(stepInfo, artifact);
	PropertyStates propertyStates = 
		[checkProperty(property, artifact.propertyReport.history, maps) 
		| Property property <- artifact.propertyReport.properties];
	
	return [<stepInfo, maps, propertyStates>];
}

public ExtendedTileMaps extractExtendedTileMaps
(
	StepInfo currentStep, 
	ExecutionArtifact artifact
)
{
	TileMap currentSymbolMap = artifact.currentState;
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

public StepInfo extractStepInfo
(
	ModuleExecution history
)
{
	int moduleIndex = history.nameIndex;
	int recipeStep = size(history.instructions) - 1;
	int ruleIndex = history.instructions[0].rules[0].nameIndex;
	Location matchLocation = <history.instructions[0].rules[0].location.x, 
														history.instructions[0].rules[0].location.y>;
	int rightHandIndex = history.instructions[0].rules[0].rightHandIndex;
	StepInfo stepInfo = 
		stepInfo(moduleIndex, recipeStep,  ruleIndex, matchLocation, rightHandIndex);
	return stepInfo;
}