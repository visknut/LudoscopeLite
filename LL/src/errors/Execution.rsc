//////////////////////////////////////////////////////////////////////////////
//
// Execution errors
// @brief        This file contains data types for execution errors.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         01-05-2018
//
//////////////////////////////////////////////////////////////////////////////

module errors::Execution

data ExecutionError
	= moduleConnection(list[str] moduleNames);
	
str errorToString(moduleConnection(list[str] moduleNames))
{
	str errorMessage = "Execution error: the following modules didn\'t get an input:";
	for (str moduleName <- moduleNames)
	{
		errorMessage += "\n <moduleName>";
	}

	return errorMessage;
}