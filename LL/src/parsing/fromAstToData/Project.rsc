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
import errors::Parsing;

/* Parses and transfers a project. */
public ParsingArtifact parseProject(loc projectFile)
{
	Environment environment = environment(projectFile, [], undefinedModule());
	LudoscopeProject project = ludoscopeProject([], ());
	ParsingArtifact artifact = parsingArtifact(environment, project);
	
	if (exists(projectFile))
	{
		Alphabet newAlphabet = ();
		/* Try parsing the alphabet file and catch any errors thrown. */
		try 
		{
			Project abstractProject = parseProjectToAST(projectFile);
			if (abstractProject.version == "0.6f")
			{
				for (Declaration declaration <- sort(abstractProject.declarations))
				{
					artifact = parseDeclaration(artifact, declaration);
					/* Check for errors. */
					if (size(artifact.environment.errors) > 0)
					{
						return artifact;
					}
				}
			} 
			else {
				artifact.environment.errors += 
					[errors::Parsing::version(abstractProject.version)];
			}
		}
		catch ParseError(loc errorLocation):
		{
			artifact.environment.errors += [errors::Parsing::parsing(errorLocation)];
		}
		catch Ambiguity(loc errorLocation, str usedSyntax, str parsedText):
		{
			artifact.environment.errors += [errors::Parsing::ambiguity(errorLocation, usedSyntax)];
		}
		catch IllegalArgument(value v, str message):
		{
			artifact.environment.errors += [errors::Parsing::imploding(projectFile)];
		}
	}
	else
	{
		artifact.environment.errors += [errors::Parsing::fileNotFound(alphabetFile)];
	}
	return artifact;
}

/* Parses and transfers an alphabet. */
private ParsingArtifact parseDeclaration(ParsingArtifact artifact,
	declaredAlphabet(parsing::languages::project::AST::Alphabet declaredAlphabet))
{
	str fileName = removeQuotes(declaredAlphabet.name);
	loc alphabetFile = fileLocation(artifact.environment.projectFile, 
		fileName, ".alp");
	if (exists(alphabetFile))
	{
		Alphabet newAlphabet = ();
		/* Try parsing the alphabet file and catch any errors thrown. */
		try 
		{
			parsing::languages::alphabet::AST::Alphabet abstractAlphabet 
				= parseAlphabetToAST(alphabetFile);
			/* Transfer parsed alphabet to the new data structure. */
			int i = 0;
			for (Symbol symbol <- abstractAlphabet.symbols)
			{
				newAlphabet += (symbol.name : i);
				i += 1;
			}
			artifact.project.alphabets += (fileName : newAlphabet);
		}
		catch ParseError(loc errorLocation):
		{
			artifact.environment.errors += [errors::Parsing::parsing(errorLocation)];
		}
		catch Ambiguity(loc errorLocation, str usedSyntax, str parsedText):
		{
			artifact.environment.errors += [errors::Parsing::ambiguity(errorLocation, usedSyntax)];
		}
		catch IllegalArgument(value v, str message):
		{
			artifact.environment.errors += [errors::Parsing::imploding(alphabetFile)];
		}
	}
	else
	{
		artifact.environment.errors += [errors::Parsing::fileNotFound(alphabetFile)];
	}
	return artifact;
}

/* Parses and transfers a module. */
private ParsingArtifact parseDeclaration(ParsingArtifact artifact,
	declaredModule(Module declaredModule))
{
	artifact.environment.newModule = 
		ludoscopeModule("none", [], "none", [[]], (), []);
	
	/* Transfer module name. */
	artifact.environment.newModule.name = cleanModuleName(declaredModule.name);
	/* Transfer module inputs. */
	for (str input <- declaredModule.inputs)
	{
		artifact.environment.newModule.inputs += [removeQuotes(input)];
	}
	/* Transfer alphabet name. */
	artifact.environment.newModule.alphabetName = 
		cleanAlphabetName(declaredModule.alphabet);
	/* Parse and transfer recipe. */
	if (cleanRecipeBool(declaredModule.recipe) == "true")
	{
		artifact = parseRecipe(artifact, cleanModuleName(declaredModule.name));
		/* Check for errors. */
		if (size(artifact.environment.errors) > 0)
		{
			return artifact;
		}
	}
	/* Parse and transfer grammar. */
	artifact = parseGrammar(artifact, cleanModuleName(declaredModule.name));
	/* Check for errors. */
	if (size(artifact.environment.errors) > 0)
	{
		return artifact;
	}
	
	artifact.project.modules += [artifact.environment.newModule];
	artifact.environment.newModule = undefinedModule();
	return artifact;
}

/* Hasn't been implemented yet in LL. */
private ParsingArtifact parseDeclaration(ParsingArtifact artifact,
	declaredOption(Option declaredOption))
{
	return artifact;
}

/* Hasn't been implemented yet in LL. */
private ParsingArtifact parseDeclaration(ParsingArtifact artifact,
	declaredRegister(Register declaredRegister))
{
	return artifact;
}