//////////////////////////////////////////////////////////////////////////////
//
// Tests for extracting module hierarchy
// @brief        This file contains test functions to check if the module
//							 hierarchy if extracted correctly.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         17-05-2018
//
//////////////////////////////////////////////////////////////////////////////

module tests::execution::ModuleHierarchy

import List;
import parsing::DataStructures;
import execution::DataStructures;
import execution::ModuleHierarchy;

public bool runAllTests()
{
	return simpleHierarchy()
	&& complexHierarchy()
	&& incorrectHierarchy();
}

private test bool simpleHierarchy()
{
	/* Arrange */
	LudoscopeModule module1 = ludoscopeModule("module1", [], "", [[]], (), []);
	LudoscopeModule module2 = ludoscopeModule("module2", ["module1"], "", [[]], (), []);
	LudoscopeModule module3 = ludoscopeModule("module3", ["module2"], "", [[]], (), []);
	LudoscopeProject project = ludoscopeProject([module1, module2, module3], (), []);
	
	ModuleHierarchy expectedOutput = [{module1}, {module2}, {module3}];
	
	/* Act */
	PreparationArtifact artifact = extractModuleHierarchy(project);
	
	/* Assert */
	return artifact.errors == []
	&& artifact.hierarchy == expectedOutput;
}

private test bool complexHierarchy()
{
	/* Arrange */
	LudoscopeModule module1 = ludoscopeModule("module1", [], "", [[]], (), []);
	LudoscopeModule module2 = ludoscopeModule("module2", ["module1"], "", [[]], (), []);
	LudoscopeModule module3 = ludoscopeModule("module3", ["module1"], "", [[]], (), []);
	LudoscopeModule module4 = ludoscopeModule("module4", ["module2", "module3"], "", [[]], (), []);
	LudoscopeProject project = ludoscopeProject([module1, module2, module3, module4], (), []);
	
	ModuleHierarchy expectedOutput = [{module1}, {module2, module3}, {module4}];
	
	/* Act */
	PreparationArtifact artifact = extractModuleHierarchy(project);
	
	/* Assert */
	return artifact.errors == [] && artifact.hierarchy == expectedOutput;
}

private test bool incorrectHierarchy()
{
	/* Arrange */
	LudoscopeModule module1 = ludoscopeModule("module1", [], "", [[]], (), []);
	LudoscopeModule module2 = ludoscopeModule("module2", ["module2"], "", [[]], (), []);
	LudoscopeModule module3 = ludoscopeModule("module3", ["module3"], "", [[]], (), []);
	LudoscopeProject project = ludoscopeProject([module1, module2, module3], (), []);
	
	ModuleHierarchy expectedOutput = [{module1}];
	
	/* Act */
	PreparationArtifact artifact = extractModuleHierarchy(project);
	
	/* Assert */
	return size(artifact.errors) == 1	&& artifact.hierarchy == expectedOutput;
}