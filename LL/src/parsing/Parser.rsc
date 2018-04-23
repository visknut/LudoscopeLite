//////////////////////////////////////////////////////////////////////////////
//
// Parser for LL projects
// @brief        This file contains the public interface for parsing
//							 a Ludoscope project.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         17-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::Parser

import IO;
import Exception;
import List;

import parsing::languages::project::AST;
import parsing::languages::alphabet::AST;
import parsing::languages::recipe::AST;
import parsing::languages::grammar::AST;

import parsing::fromAstToData::CreateSyntaxTree;
import parsing::fromAstToData::TransformSyntaxTree;

import parsing::DataStructures;
import errors::Parsing;
import util::string;

alias AbstractProjectList = list[parsing::languages::project::AST::Project];
alias AbstractGrammarMap = map[str, parsing::languages::grammar::AST::Grammar] ;
alias AbstractAlphabetMap = map[str, parsing::languages::alphabet::AST::Alphabet];
alias AbstractRecipeMap = map[str, parsing::languages::recipe::AST::Recipe];

data SyntaxTree
	= syntaxTree(AbstractProjectList project, 
	AbstractGrammarMap grammars, 
	AbstractAlphabetMap alphabets, 
	AbstractRecipeMap recipes,
	list[ParsingError] errors);

public SyntaxTree parseFile(loc file, SyntaxTree syntaxTree)
{
	if (exists(file))
	{
		try 
		{
			switch (file.extension)
			{
				case "lsp" : syntaxTree.project += [parseProjectToAST(file)];
				case "grm" : syntaxTree.grammars += (fileName(file) : parseGrammarToAST(file));
				case "alp" : syntaxTree.alphabets += (fileName(file) : parseAlphabetToAST(file));
				case "rcp" : syntaxTree.recipes += (fileName(file) : parseRecipeToAST(file));
				default : syntaxTree.errors += [errors::Parsing::extension(file)];
			}
		}
		catch ParseError(loc errorLocation):
		{
			syntaxTree.errors += [errors::Parsing::parsing(errorLocation)];
		}
		catch Ambiguity(loc errorLocation, str usedSyntax, str parsedText):
		{
			syntaxTree.errors += [errors::Parsing::ambiguity(errorLocation, usedSyntax)];
		}
		catch IllegalArgument(value v, str message):
		{
			syntaxTree.errors += [errors::Parsing::imploding(file)];
		}
	}
	else
	{
		syntaxTree.errors += [errors::Parsing::fileNotFound(file)];
	}
	return syntaxTree;
}