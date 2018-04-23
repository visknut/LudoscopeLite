module parsing::GatherFiles

import parsing::Parser;
import parsing::languages::project::AST;
import util::string;

public list[loc] gatherFileLocations(SyntaxTree syntaxTree, loc projectFile)
{
	list[loc] fileLocations = [];

	visit(syntaxTree)
	{
		case lspmodule(str name, str alphabet, str position, str moduleType, str fileName,
			str match, list[str] inputs, str maxIterations,	str moduleFilter,	str grammar,
			str executionType, str recipe, str showMembers, str alwaysStartWithToken) :
			{
				fileLocations += [fileLocation(projectFile, cleanGrammarName(name), ".grm")];
				if (cleanRecipeBool(recipe) == "true")
				{
					fileLocations += [fileLocation(projectFile, cleanGrammarName(name), ".rcp")];
				}
			}
		case alphabet(str name, Position position) :
		{
			fileLocations += [fileLocation(projectFile, removeQuotes(name), ".alp")];
		}
	}
	return fileLocations;
}