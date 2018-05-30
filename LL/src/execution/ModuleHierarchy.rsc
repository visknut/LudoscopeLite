//////////////////////////////////////////////////////////////////////////////
//
// Module Hierarchy
// @brief        This file contains functions that extract the order in which
//							 modules should be executed.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         12-05-2018
//
//////////////////////////////////////////////////////////////////////////////

module execution::ModuleHierarchy

import IO;
import List;
import errors::Execution;
import parsing::DataStructures;
import execution::DataStructures;

public PreparationArtifact extractModuleHierarchy(LudoscopeProject project)
{
	list[LudoscopeModule] modules = project.modules;
	list[str] checkedModules = [];
	PreparationArtifact artifact = preparationArtifact([], []);
	while (modules != [])
	{
		list[LudoscopeModule] readyModules = 
			findReadyModules(modules, checkedModules);
			
		if (readyModules == [])
		{
			list[str] moduleNames = [m.name | LudoscopeModule m <- modules]; 
			artifact.errors += [moduleConnection(moduleNames)];
			return artifact;
		}
		
		artifact.hierarchy += [toSet(readyModules)];
		checkedModules += [readyModule.name | LudoscopeModule readyModule <- readyModules];
		modules -= readyModules;
	}
	return artifact;
}

private list[LudoscopeModule] findReadyModules
(
	list[LudoscopeModule] modules,
	list[str] checkedModules
)
{
	list[LudoscopeModule] readyModules = [m | 
		LudoscopeModule m <- modules, 
		inputReady(m, checkedModules)];
	return readyModules;
}


private bool inputReady(LudoscopeModule ludoscopeModule, list[str] checkedModules)
{
	list[str] inputsRemaining = [n | 
		n <- ludoscopeModule.inputs, 
		n notin checkedModules];
	return inputsRemaining == [];
}