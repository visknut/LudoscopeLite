//////////////////////////////////////////////////////////////////////////////
//
// Parser for LL projects
// @brief        This file contains the public interface for parsing
//							 a Ludoscope project.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         17-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::ParserAPI

import IO;
import parsing::fromAstToData::Project;

public void parseLudoscopeProject(loc projectFile)
{
	println(parseProject(projectFile));
}