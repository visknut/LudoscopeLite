module execution::Controller

import List;

import errors::Execution;

import parsing::Interface;
import parsing::DataStructures;

import execution::instructions::Recipe;
import execution::DataStructures;

public ExecutionArtifact executeProject(LudoscopeProject project)
{
	list[LudoscopeModule] modules = project.modules;
	 ExecutionArtifact artifact = executionArtifact((), []);
	
	/* Execute all modules. */
	while (modules != [])
	{
		list[LudoscopeModule] readyModules = 
			findReadyModules(modules, artifact.output);
			
		if (readyModules == [])
		{
			list[str] moduleNames = [m.name | m <- modules];
			artifact.errors += [moduleConnection(moduleNames)];
			return artifact;
		}
		
		LudoscopeModule currentModule = head(readyModules);
		modules -= currentModule;
		
		artifact.output += 
			(currentModule.name : executeModule(currentModule, artifact.output));
	}
	
	return artifact;
}

public TileMap executeModule(LudoscopeModule modulez, OutputMap input)
{
	return [[]];
}

//////////////////////////////////////////////////////////////////////////////
// Utility functions.
////////////////////////////////////////////////////////////////////////////// 

private bool inputReady(LudoscopeModule ludoscopeModule, OutputMap output)
{
	list[str] inputsRemaining = [n | n <- ludoscopeModule.inputs, n notin output];
	return inputsRemaining == [];
}

private list[LudoscopeModule] findReadyModules(list[LudoscopeModule] modules,
	OutputMap output)
{
	list[LudoscopeModule] readyModules = 
		[m | LudoscopeModule m <- modules, inputReady(m, output)];
	return readyModules;
}