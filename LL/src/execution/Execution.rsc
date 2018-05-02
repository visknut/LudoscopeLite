//////////////////////////////////////////////////////////////////////////////
//
// Project execution
// @brief        This file contains functions that execute a parsed LL project.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         01-05-2018
//
//////////////////////////////////////////////////////////////////////////////

module execution::Execution

import List;

import errors::Execution;

import parsing::Interface;
import parsing::DataStructures;

import execution::instructions::Instructions;
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

public TileMap executeModule(LudoscopeModule ludoscopeModule, OutputMap input)
{
	switch (size(ludoscopeModule.inputs))
	{
		case 0 : return executeRecipe(ludoscopeModule.startingState, 
			ludoscopeModule.rules, 
			ludoscopeModule.recipe);
		case 1 : return executeRecipe(input[head(ludoscopeModule.inputs)], 
			ludoscopeModule.rules, 
			ludoscopeModule.recipe);
		default :
			// TODO: add merge functions.
			return [[]];
	}
}

public TileMap executeRecipe(TileMap tileMap, RuleMap rules, Recipe recipe)
{
	for (Instruction instruction <- recipe)
	{
		tileMap = executeInstruction(tileMap, rules, instruction);
	}
	return tileMap;
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