//////////////////////////////////////////////////////////////////////////////
//
// Parser for LL projects
// @brief        This file contains the initiation of the parsing process.
//							 The main function should return a parsed LL project.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         ??-04-2018 (not finished)
//
//////////////////////////////////////////////////////////////////////////////

module parsing::parser

import languages;
import parsing::DataStructures;

public LudoscopeProject parseLudoScopeProject(loc projectFile)
{
	LSP abstractProject = lsp_implode(lsp_parse(projectFile));
	list[map[str, int]] alphabets = gatherAlphabets(LSP.alphabets);
	return false;
}

private list[map[str, int]] gatherAlphabets(list[Alphabet] alphabetNames)
{
		
}