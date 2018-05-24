//////////////////////////////////////////////////////////////////////////////
//
// Language Registration
// @brief        This file contains datastructures needed for execution an LL
//							 project.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         01-05-2018
//
//////////////////////////////////////////////////////////////////////////////

module execution::DataStructures

import execution::lpl::PropertyHistory;
import execution::lpl::PropertyValidation;
import execution::history::DataStructures;
import parsing::DataStructures;
import errors::Execution;

alias OutputMap = map[int, TileMap];
alias ModuleHierarchy = list[set[LudoscopeModule]];
alias Location =  tuple[int x, int y];

data ExecutionArtifact =
	executionArtifact(OutputMap output,
										TileMap currentState,
										ExecutionHistory history,
										PropertyReport propertyReport,
										list[ExecutionError] errors);
	
data PreparationArtifact =
	preparationArtifact(ModuleHierarchy hierarchy, list[ExecutionError] errors);

//////////////////////////////////////////////////////////////////////////////
// LPL.
//////////////////////////////////////////////////////////////////////////////

data PropertyReport 
	= propertyReport(list[Property] properties, PropertyHistory history);

alias PropertyHistory = lrel[StepInfo stepInfo, 
													 ExtendedTileMaps mapState, 
													 list[bool] propertyStates];
													 
data StepInfo =
	stepInfo(int moduleIndex, 
					 int recipeStep,
					 int ruleIndex,
					 Location matchLocation, 
					 int rightHandIndex);

data ExtendedTileMaps
	=	extendedTileMaps(TileMap moduleIndex, 
						 TileMap ruleIndex, 
						 TileMap tileIndex);