//////////////////////////////////////////////////////////////////////////////
//
// Project execution
// @brief        This file contains functions that execute a parsed LL project.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         01-05-2018
//
//////////////////////////////////////////////////////////////////////////////

module execution::Execution

import IO;
import List;

import errors::Execution;

import parsing::Interface;
import parsing::DataStructures;

import execution::instructions::Instructions;
import execution::DataStructures;
import execution::ModuleHierarchy;
import execution::history::DataStructures;

public ExecutionArtifact executeProject(LudoscopeProject project)
{
	list[LudoscopeModule] modules = project.modules;
	ExecutionArtifact artifact = executionArtifact((), [], [], []);
	PreparationArtifact preparationArtifact = 
		extractModuleHierarchy(project);
		
	if (preparationArtifact.errors != [])
	{
		artifact.errors = preparationArtifact.errors;
		return artifact;
	}
	
	/* Execute all modules. */
	for (set[LudoscopeModule] moduleGroup <- preparationArtifact.hierarchy)
	{
		for (LudoscopeModule currentModule <- moduleGroup)
		{
			artifact = executeModule(artifact, currentModule);
		}
	}
	artifact.history = reverseHistory(artifact.history);
	return artifact;
}

public ExecutionArtifact executeModule
(
	ExecutionArtifact artifact, 
	LudoscopeModule ludoscopeModule
)
{
	artifact.history = 
		push(moduleExecution(ludoscopeModule.name, []), artifact.history);
	switch (size(ludoscopeModule.inputs))
	{
		case 0 : 
		{
			artifact.currentState = ludoscopeModule.startingState;
			artifact = executeRecipe(artifact,
				ludoscopeModule.rules, 
				ludoscopeModule.recipe);
		}
		case 1 : 
		{
			artifact.currentState = artifact.output[head(ludoscopeModule.inputs)];
			artifact = executeRecipe(artifact,
				ludoscopeModule.rules,
				ludoscopeModule.recipe);
		}
		default :
		{
			break;
			// TODO: add merge functions.
		}

	}
	artifact.output = (ludoscopeModule.name : artifact.currentState);
	return artifact;
}

public ExecutionArtifact executeRecipe
(
	ExecutionArtifact artifact,
	RuleMap rules,
	Recipe recipe
)
{
	for (Instruction instruction <- recipe)
	{
		artifact.history[0].instructions = 
			push(instructionExecution([]), artifact.history[0].instructions);
		artifact = executeInstruction(artifact, rules, instruction);
	}
	return artifact;
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

private ExecutionHistory reverseHistory(ExecutionHistory history)
{
	history = visit (history)
	{
		case list[ModuleExecution] timeline => reverse(timeline)
		case list[InstructionExecution] timeline => reverse(timeline)
		case list[RuleExecution] timeline => reverse(timeline)
	};
	return history;
}