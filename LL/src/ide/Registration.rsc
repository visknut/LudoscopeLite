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
import parsing::languages::lpl::Syntax;

str ALPHABETNAME = "Ludoscope Alphabet";
str PROJECTNAME = "Ludoscope Project";
str GRAMMARNAME = "Ludoscope Grammar";
str RECIPENAME = "Ludoscope Recipe";
str PROPERTIESNAME = "Ludoscope Properties";

str ALPHABETABBREVIATION = "alp";
str PROJECTABBREVIATION = "lsp";
str GRAMMARABBREVIATION = "grm";
str RECIPENABBREVIATION = "rcp";
str PROPERTIESABBREVIATTION = "lpl";

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
	registerLanguage(PROPERTIESNAME, PROPERTIESABBREVIATTION, parseLpl);
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
  registerContributions(PROPERTIESNAME, styleContributions);
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
	        "LL: basic functions",
	        [
	          action("Parse and transform", parseAndTransform),
	          action("Execute Project", executeProject)
	        ]
	       )
	      ),
	    popup
	    (
	       menu
	       (
	       	"LL: Timed execution",
	        [
	          action("1x", timeExecution1x),
	          action("100x", timeExecution100x),
	          action("10000x", timeExecution10000x)
	        ]
	      )
	    )
	  };
	  
	registerContributions(PROJECTNAME, menuItems);
}