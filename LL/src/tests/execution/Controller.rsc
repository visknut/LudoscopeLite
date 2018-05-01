module tests::execution::Controller

import execution::Controller;
import execution::DataStructures;
import parsing::DataStructures;
import List;

public bool runAllTests()
{
	return executeSimpleProject()
	&& executeComplexProject()
	&& executeIncorrectProject()
	&& testExecuteModule();
}

private test bool executeSimpleProject()
{
	/* Arrange */
	LudoscopeModule module1 = ludoscopeModule("module1", [], "", [[]], (), []);
	LudoscopeModule module2 = ludoscopeModule("module2", ["module1"], "", [[]], (), []);
	LudoscopeModule module3 = ludoscopeModule("module3", ["module2"], "", [[]], (), []);
	LudoscopeProject project = ludoscopeProject([module1, module2, module3], ());
	
	OutputMap expectedOutput = ("module1":[[]],"module2":[[]],"module3":[[]]);
	
	/* Act */
	ExecutionArtifact artifact = executeProject(project);
	
	/* Assert */
	return artifact.errors == []
	&& artifact.output == expectedOutput;
}

private test bool executeComplexProject()
{
	/* Arrange */
	LudoscopeModule module1 = ludoscopeModule("module1", [], "", [[]], (), []);
	LudoscopeModule module2 = ludoscopeModule("module2", ["module1"], "", [[]], (), []);
	LudoscopeModule module3 = ludoscopeModule("module3", ["module2"], "", [[]], (), []);
	LudoscopeModule module4 = ludoscopeModule("module4", ["module2", "module3"], "", [[]], (), []);
	LudoscopeProject project = ludoscopeProject([module1, module2, module3, module4], ());
	
	OutputMap expectedOutput = ("module1":[[]],"module2":[[]],"module3":[[]],"module4":[[]]);
	
	/* Act */
	ExecutionArtifact artifact = executeProject(project);
	
	/* Assert */
	return artifact.errors == [] && artifact.output == expectedOutput;
}

private test bool executeIncorrectProject()
{
	/* Arrange */
	LudoscopeModule module1 = ludoscopeModule("module1", [], "", [[]], (), []);
	LudoscopeModule module2 = ludoscopeModule("module2", ["module2"], "", [[]], (), []);
	LudoscopeModule module3 = ludoscopeModule("module3", ["module3"], "", [[]], (), []);
	LudoscopeProject project = ludoscopeProject([module1, module2, module3], ());
	
	OutputMap expectedOutput = ("module1":[[]]);
	
	/* Act */
	ExecutionArtifact artifact = executeProject(project);
	
	/* Assert */
	return size(artifact.errors) == 1	&& artifact.output == expectedOutput;
}

private test bool testExecuteModule()
{
	/* Arrange */
	
	/* Act */
	
	/* Assert */
	return true;
}