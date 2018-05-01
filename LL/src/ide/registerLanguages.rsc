module ide::registerLanguages

import IO;
import util::IDE;
import String;
import ParseTree;
import vis::Figure;

import parsing::Interface;
import parsing::DataStructures;
import parsing::languages::alphabet::Syntax;
import parsing::languages::project::Syntax;
import parsing::languages::grammar::Syntax;
import parsing::languages::recipe::Syntax;

import errors::Parsing;

public void registerLanguages()
{
	registerLanguage("Ludoscope Alphabet", "alp",  parseAlphabet);
	registerLanguage("Ludoscope Project", "lsp",  parsing::languages::project::Syntax::parseProject);
	registerLanguage("Ludoscope Grammar", "grm",  parseGrammar);
	registerLanguage("Ludoscope Recipe", "rcp",  parseRecipe);
	
	Contribution style =
    categories
    (
      (
        "String" : {foregroundColor(color("purple"))},
        "Name" : {bold()},
        "ColorCode" : {foregroundColor(color("Violet"))}
      )
    );
  
  set[Contribution] contributions =
  {
  	style
  };
  
  set[Contribution] projectContributions =
  {
  	style,
  	popup
    (
      menu
      (
        "Ludoscope Lite",
        [
          action("Parse and transform", parsy)
        ]
      )
    )
  };
  
  registerContributions("Ludoscope Alphabet", contributions);
  registerContributions("Ludoscope Project", projectContributions);
  registerContributions("Ludoscope Grammar", contributions);
  registerContributions("Ludoscope Recipe", contributions);
}

private void parsy(Tree tree, loc projectFile)
{
	TransformationArtifact artifact = parseAndTransform(toLocation(projectFile.uri));
	if (artifact.errors == [])
	{
		iprintln(artifact.project);
	} 
	else {
		println("There were errors found while parsing the project:");
		for (ParsingError error <- artifact.errors)
		{
			println(errorToString(error));
		}
	}
}