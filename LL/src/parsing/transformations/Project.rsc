//////////////////////////////////////////////////////////////////////////////
//
// Transform Project
// @brief        Functions that move the relevant content from the AST to
//							 a new ADT declared in DataStructures.rsc.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         23-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::transformations::Project

import parsing::Parser;
import parsing::languages::grammar::AST;
import parsing::DataStructures;
import util::string;

// TODO: implement options and registers.
public TransformationArtifact transformProject(TransformationArtifact artifact, 
	SyntaxTree syntaxTree)
{
	visit (syntaxTree.project[0])
	{
		case lspmodule(str name, str alphabet, str position, str moduleType, str fileName,
			str match, list[str] inputs, str maxIterations,	str moduleFilter,	str grammar,
			str executionType, str recipe, str showMembers, str alwaysStartWithToken) :
		{
			list[str] cleanInputs = [removeQuotes(input) | str input <- inputs];
			artifact.project.modules +=
				[ludoscopeModule(cleanGrammarName(name), 
												cleanInputs,
												cleanAlphabetName(alphabet),
												[[]], 
												(), 
												[])];
		}
	}
	
	return artifact;
}
