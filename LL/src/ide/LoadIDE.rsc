//////////////////////////////////////////////////////////////////////////////
//
// Load IDE
// @brief        This file can be run to load an IDE for LL in ecplise.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         02-05-2018
//
//////////////////////////////////////////////////////////////////////////////

module ide::LoadIDE

import IO;
import ide::Registration;

public void main()
{
	registerLanguages();
	addSyntaxHighLights();
	addMenuItems();
	println("IDE loaded.");
}