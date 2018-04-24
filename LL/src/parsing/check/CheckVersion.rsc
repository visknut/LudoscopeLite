//////////////////////////////////////////////////////////////////////////////
//
// Check versions
// @brief        Function for checking the versions of project 
//							 and grammars files.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         24-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::check::CheckVersion

import parsing::languages::project::AST;
import parsing::languages::grammar::AST;

import parsing::Parser;
import errors::Parsing;

alias AbstractGrammar = parsing::languages::grammar::AST::Grammar;
alias AbstractProject = parsing::languages::project::AST::Project;

public SyntaxTree checkVersion(SyntaxTree syntaxTree)
{
	for (AbstractProject abstractProject <- syntaxTree.project)
	{
		if (abstractProject.version != "0.6f")
		{
				syntaxTree.errors += [version(abstractProject.version)];
		}
	}

	for (str grammarName <- syntaxTree.grammars)
	{
		AbstractGrammar abstractGrammar = syntaxTree.grammars[grammarName];
		if (abstractGrammar.version != "0.6f")
		{
			syntaxTree.errors += [version(abstractGrammar.version)];
		}
	}
	return syntaxTree;
}
