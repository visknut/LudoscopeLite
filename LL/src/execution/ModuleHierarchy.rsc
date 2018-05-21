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
	list[int] checkedModules = [];
	PreparationArtifact artifact = preparationArtifact([], []);
	while (modules != [])
	{
		list[LudoscopeModule] readyModules = 
			findReadyModules(modules, checkedModules);
			
		if (readyModules == [])
		{
			list[int] moduleIndexes = [m.nameIndex | LudoscopeModule m <- modules];
			list[str] moduleNames = [project.moduleNames[moduleIndex] | int moduleIndex <- moduleIndexes]; 
			artifact.errors += [moduleConnection(moduleNames)];
			return artifact;
		}
		
		artifact.hierarchy += [toSet(readyModules)];
		checkedModules += [readyModule.nameIndex | LudoscopeModule readyModule <- readyModules];
		modules -= readyModules;
	}
	return artifact;
}

private list[LudoscopeModule] findReadyModules
(
	list[LudoscopeModule] modules,
	list[int] checkedModules
)
{
	list[LudoscopeModule] readyModules = [m | 
		LudoscopeModule m <- modules, 
		inputReady(m, checkedModules)];
	return readyModules;
}


private bool inputReady(LudoscopeModule ludoscopeModule, list[int] checkedModules)
{
	list[int] inputsRemaining = [n | 
		n <- ludoscopeModule.inputs, 
		n notin checkedModules];
	return inputsRemaining == [];
}