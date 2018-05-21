module execution::lpl::PropertyHistory

import parsing::DataStructures;

alias PropertyHistory = list[PropertyStep];
	
alias PropertyStep = tuple[StepInfo stepInfo, 
													 extendedTileMap mapState, 
													 PropertyStates propteryStates];
													 
data StepInfo =
	stepInfo(int moduleIndex, 
					 int recipeStep, 
					 Coordinates matchLocation, 
					 int rightHandIndex);

alias extendedTileMap = list[list[TileInfo]];
data TileInfo
	=	tileInfo(int moduleIndex, 
						 str ruleIndex, 
						 int tileIndex);
	
alias PropertyStates = list[bool];

// Generate a PropertyMap for each step in the history.
// Check every property for each propertyMap.

