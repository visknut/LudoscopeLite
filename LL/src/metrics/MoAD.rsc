//////////////////////////////////////////////////////////////////////////////
//
// Implementation of MoAD (Metric of Added Detail)
// @brief        This file contains the data structures and the functions
//							 needed to evaluate the amount of detail that is added by each
//							 rule in a project.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         05-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module metrics::MoAD

import IO;
import List;
import parsing::DataStructures;

alias SymbolHierarchy = list[SymbolGroup];
alias ModuleHierarchy = list[set[LudoscopeModule]];
alias SymbolGroup = set[int];

public void calculateMoAD(LudoscopeProject project)
{
	return;
}