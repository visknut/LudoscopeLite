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
import Set;

import errors::Execution;

import parsing::Interface;
import parsing::DataStructures;

import execution::instructions::Instructions;
import execution::DataStructures;
import execution::ModuleHierarchy;

import analysis::sanrWrapper::PropertyHistory;
import sanr::DataStructures;

public ExecutionArtifact executeProject(LudoscopeProject project)
{
	iprintln(project);
	list[LudoscopeModule] modules = project.modules;
	PreparationArtifact preparationArtifact =  extractModuleHierarchy(project);
		
	if (preparationArtifact.errors != [])
	{
		artifact.errors = preparationArtifact.errors;
		return artifact;
	}
	
	/* Initiliaze Property Report */
	LudoscopeModule ludoscopeModule = getOneFrom(preparationArtifact.hierarchy[0]);
	int width = size(ludoscopeModule.startingState[0]);
	int height = size(ludoscopeModule.startingState);
	PropertyReport propertyReport = 
		initializeReport(width, height, project.specification);
		
	ExecutionArtifact artifact = executionArtifact((), [], [], propertyReport, []);
	
	/* Execute all modules. */
	for (set[LudoscopeModule] moduleGroup <- preparationArtifact.hierarchy)
	{
		for (LudoscopeModule currentModule <- moduleGroup)
		{
			artifact = executeModule(artifact, currentModule);
		}
	}
	artifact.history = reverse(artifact.history);
	return artifact;
}

public ExecutionArtifact executeModule
(
	ExecutionArtifact artifact, 
	LudoscopeModule ludoscopeModule
)
{
	switch (size(ludoscopeModule.inputs))
	{
		case 0 : 
		{
			artifact.currentState = ludoscopeModule.startingState;
			artifact = executeRecipe(artifact, ludoscopeModule);
		}
		case 1 : 
		{
			artifact.currentState = artifact.output[head(ludoscopeModule.inputs)];
			artifact = executeRecipe(artifact, ludoscopeModule);
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
	LudoscopeModule \module
)
{
	Recipe recipe = \module.recipe;
	for (Instruction instruction <- recipe)
	{
		artifact = executeInstruction(artifact, \module, instruction);
	}
	return artifact;
}

//////////////////////////////////////////////////////////////////////////////
// Utility functions.
////////////////////////////////////////////////////////////////////////////// 

//private ExecutionHistory reverseHistory(ExecutionHistory history)
//{
//	history = visit (history)
//	{
//		case list[ModuleExecution] timeline => reverse(timeline)
//		case list[InstructionExecution] timeline => reverse(timeline)
//		case list[RuleExecution] timeline => reverse(timeline)
//	};
//	return history;
//}