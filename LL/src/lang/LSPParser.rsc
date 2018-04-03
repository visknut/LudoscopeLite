module lang::LSPParser

import lang::alp;
import lang::grm;
import lang::lsp;
import lang::rcp;

public bool parseLudoScopeProject(loc projectFile)
{
	return false;
}

public void testparseLudoScopeProject()
{
	parseLudoScopeProject(|project://LL/src/lang/lsp/test.lsp|);
}