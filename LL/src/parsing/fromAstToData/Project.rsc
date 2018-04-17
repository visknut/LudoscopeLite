//////////////////////////////////////////////////////////////////////////////
//
// Transfer project files
// @brief        This file contains functions that transfers the data from the
//							 The AST to the data structures.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         17-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::fromAstToData::Project

import IO;
import Exception;
import List;

import parsing::fromAstToData::Recipe;
import parsing::fromAstToData::Grammar;

import parsing::languages::project::AST;
import parsing::languages::alphabet::AST;
import parsing::languages::recipe::AST;

import parsing::DataStructures;
import util::string;

public ProjectInformation parseProject(loc projectFile)
{
	LudoscopeProject emptyProject = ludoscopeProject([], ());
	ProjectInformation projectInfo = projectInformation(emptyProject, projectFile);
	Project abstractProject = parseProjectToAST(projectFile);
	if (abstractProject.version == "0.6f")
	{
		for (Declaration declaration <- sort(abstractProject.declarations))
		{
			projectInfo = parseDeclaration(declaration, projectInfo);
		}
	} 
	else {
		println("Error: incorrect version. LL was build for version 0.6 of Ludoscope.");
	}
	return projectInfo;
}

private ProjectInformation parseDeclaration(
	declaredAlphabet(parsing::languages::project::AST::Alphabet declaredAlphabet),
	ProjectInformation projectInfo)
{
	str fileName = removeQuotes(declaredAlphabet.name);
	loc alphabetFile = fileLocation(projectInfo.projectFile, fileName, ".alp");
	if (exists(alphabetFile))
	{
		Alphabet newAlphabet = (); 
		parsing::languages::alphabet::AST::Alphabet abstractAlphabet 
			= parseAlphabetToAST(alphabetFile);
			
		int i = 0;
		for (Symbol symbol <- abstractAlphabet.symbols)
		{
			newAlphabet += (symbol.name : i);
			i += 1;
		}
		projectInfo.project.alphabets += (fileName : newAlphabet);
	}
	else
	{
		println("Error: defined file does not exist");
		throw(PathNotFound(alphabetFile));
	}
	return projectInfo;
}

private ProjectInformation parseDeclaration(
	declaredModule(Module declaredModule),
	ProjectInformation projectInfo)
{
	LudoscopeModule newModule = 
		ludoscopeModule("none", [], "none", [[]], (), []);
	
	newModule.name = cleanModuleName(declaredModule.name);
	for (str input <- declaredModule.inputs)
	{
		newModule.inputs += [removeQuotes(input)];
	}
	newModule.alphabetName = cleanAlphabetName(declaredModule.alphabet);
	
	if (cleanRecipeBool(declaredModule.recipe) == "true")
	{
		newModule.recipe = parseRecipe(cleanModuleName(declaredModule.name), 
			projectInfo);
	}
	
	newModule = parseGrammar(cleanModuleName(declaredModule.name), 
		projectInfo, newModule);
	
	projectInfo.project.modules += [newModule];
	return projectInfo;
}

private ProjectInformation parseDeclaration(
	declaredOption(Option declaredOption),
	ProjectInformation projectInfo)
{
	return projectInfo;
}

private ProjectInformation parseDeclaration(
	declaredRegister(Register declaredRegister),
	ProjectInformation projectInfo)
{
	return projectInfo;
}