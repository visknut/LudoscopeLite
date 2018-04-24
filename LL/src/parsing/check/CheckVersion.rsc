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

public SyntaxTree checkVersion(SyntaxTree syntaxTree)
{
	if (syntaxTree.project[0].version != "0.6f")
	{
			SyntaxTree.errors += [version(abstractGrammar.version)];
	}
	
	for (AbstractGrammar abstractGrammar <- syntaxTree.grammars)
	{
		if (abstractGrammar.version != "0.6f")
		{
			SyntaxTree.errors += [version(abstractGrammar.version)];
		}
	}
}
