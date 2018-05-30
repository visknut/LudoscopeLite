//////////////////////////////////////////////////////////////////////////////
//
// Utility functions
// @brief        Functions that help with the transformations.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         23-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::transformations::Utility

import List;
import parsing::DataStructures;

public int findModuleIndex(str moduleName, TransformationArtifact artifact) 
{ 
  for (int i <- [0 .. size(artifact.project.modules)]) 
  { 
    if (artifact.project.modules[i].name == moduleName)  
    { 
      return i; 
    }
  }
}

public list[bool] parseBitFlag(int bitFlag, int minimumSize)
{
	list[bool] bitList = [];
	
	while (bitFlag != 0)
	{
		if (bitFlag % 2 == 1)
		{
			bitList += [true];
		}
		else
		{
			bitList += [false];
		}
		bitFlag = bitFlag / 2;
	}
	
	for (int i <- [size(bitList) .. minimumSize])
	{
		bitList += [false];
	}
	return bitList;
}