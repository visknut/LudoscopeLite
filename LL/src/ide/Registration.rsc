//////////////////////////////////////////////////////////////////////////////
//
// Language Registration
// @brief        This file contains functions that register the languages,
//							 add syntax high ligths and menu items.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         02-05-2018
//
//////////////////////////////////////////////////////////////////////////////

module ide::Registration

import util::IDE;
import ParseTree;
import vis::Figure;

import ide::MenuFunctions;

import parsing::languages::alphabet::Syntax;
import parsing::languages::project::Syntax;
import parsing::languages::grammar::Syntax;
import parsing::languages::recipe::Syntax;

str ALPHABETNAME = "Ludoscope Alphabet";
str PROJECTNAME = "Ludoscope Project";
str GRAMMARNAME = "Ludoscope Grammar";
str RECIPENAME = "Ludoscope Recipe";

str ALPHABETABBREVIATION = "alp";
str PROJECTABBREVIATION = "lsp";
str GRAMMARABBREVIATION = "grm";
str RECIPENABBREVIATION = "rcp";

Contribution STYLE =
  categories
  (
    (
      "String" : {foregroundColor(color("purple"))},
      "Name" : {bold()},
      "ColorCode" : {foregroundColor(color("Violet"))},
      "Boolean" : {foregroundColor(color("Black")), bold()}
   	)
 	);

public void registerLanguages()
{
	registerLanguage(ALPHABETNAME, ALPHABETABBREVIATION, parseAlphabet);
	registerLanguage(PROJECTNAME, PROJECTABBREVIATION, parsing::languages::project::Syntax::parseProject);
	registerLanguage(GRAMMARNAME, GRAMMARABBREVIATION, parseGrammar);
	registerLanguage(RECIPENAME, RECIPENABBREVIATION, parseRecipe);
}

public void addSyntaxHighLights()
{
  set[Contribution] styleContributions =
  {
  	STYLE
  };
  
  registerContributions(ALPHABETNAME, styleContributions);
  registerContributions(PROJECTNAME, styleContributions);
  registerContributions(GRAMMARNAME, styleContributions);
  registerContributions(RECIPENAME, styleContributions);
}

public void addMenuItems()
{
	set[Contribution] menuItems =
	  {
	  	STYLE,
	  	popup
	    (
	      menu
	      (
	        "Ludoscope Lite",
	        [
	          action("Parse and transform", parseAndTransform),
	          action("Execute Project", executeProject)
	        ]
	      )
	    )
	  };
	  
	registerContributions(PROJECTNAME, menuItems);
}