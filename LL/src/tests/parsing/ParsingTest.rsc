module tests::parsing::ParsingTest

import IO;
import ParseTree;

import parsing::languages::grammar::Syntax;
import parsing::languages::grammar::AST;

// TODO: figure out how to make this work with multiple grammars.
public bool genericParsingTest(loc fileToParse, type[Tree] syntaxType, type[value] AST)
{
	Tree tree;
	/* First try parsing to a parse tree. */
	try {
		tree = parse(syntaxType, fileToParse);
	}
	catch ParseError(loc errorLocation):
	{
		print("Error: could not parse the file. \n@");
		println(errorLocation);
		return false;
	}
	catch Ambiguity(loc errorLocation, str usedSyntax, str parsedText):
	{
		print("Error: ambiguity found during parsing. \n@");
		println(errorLocation);
		return false;
	}
	/* Then try to implode the parse tree to an AST. */
	try {
		implode(AST, tree);
	}
	catch IllegalArgument(value v, str message):
	{
		println("Error: could not implode the parse tree to an AST");
		return false;
	}
	return true;
}