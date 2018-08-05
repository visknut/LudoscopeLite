module visual::IDE::IDE

import visual::IDE::View;

/* Prelude */
import IO;
import String;
import List;

/* salix */
import salix::HTML;
import salix::App;
import salix::lib::Dagre;
import salix::lib::CodeMirror;
import salix::lib::Mode;
import salix::Core;
import salix::SVG;

/* Parsing */
import errors::Parsing;
import parsing::Interface;
import parsing::Parser;
import parsing::DataStructures;
import parsing::languages::project::Syntax;
import parsing::languages::alphabet::Syntax;
import parsing::languages::grammar::Syntax;
import parsing::languages::recipe::Syntax;
import parsing::languages::alphabet::AST;
import sanr::language::Syntax;

/* MAD */
import analysis::madWrapper::MADFramework;
import analysis::madWrapper::DataTransformation;
import analysis::madWrapper::SymbolHierarchy;

/* Execution */
import execution::Execution;
import execution::DataStructures;
import execution::ModuleHierarchy;
import errors::Execution;

/* SAnR */
import analysis::sanrWrapper::Report;
import sanr::DataStructures;

alias Model = 
	tuple[
		View view,
		ProjectViewInfo projectViewInfo,
		ExecutionViewInfo executionViewInfo,
		BugReportViewInfo bugReportViewInfo
	];

alias ProjectViewInfo
	= tuple[
		str initialSrc,
		str updatedSrc,
		Mode mode, 
		list[str] projects, 
		str selectedProject,
		list[str] projectFiles,
		str selectedFile,
		TransformationArtifact parsedProject,
		PreparationArtifact prepairedProject,
		ProjectScore madScores
	];
	
alias ExecutionViewInfo
	= tuple[
		ExecutionArtifact executionArtifact,
		int currentStep
	];
	
alias BugReportViewInfo
	= tuple[
		Report bugReport,
		int itterations,
		BugType selectedBugType
	];
	
alias SymbolMap = list[list[SymbolInfo]];

private loc projectsFolder = |project://LL/src/visual/projects|;

App[str] LLApp()
  = app(init, 
  	view, 
  	update, 
  	|http://localhost:9105/LudoscopeLite/LL/src/visual/IDE/index.html|, 
 		|project://LL%20project|, parser = parseMsg);

Model init() {
	Mode mode = grammar2mode("LLProject", #Project);
	list[str] projects = listEntries(projectsFolder);
  str selectedProject = projects[0];
	list[str] projectFiles = listEntries(projectsFolder + selectedProject);
	str selectedFile = projectFiles[0];
	str src = readFile(projectsFolder + selectedProject + selectedFile);
	ProjectViewInfo projectViewInfo =
		<
			src, 
			src, 
			mode, 
			projects, 
			selectedProject, 
			projectFiles, 
			selectedFile, 
			emptyArtifact(),
			emptyPreparationArtifact(),
			()
		>;
		
	ExecutionViewInfo executionViewInfo =
		<
			emptyExecutionArtifact(),
			0
		>;
		
	BugReportViewInfo bugReportViewInfo =
		<
			emptyReport(),
			10,
			emptyBugType()
		>;
		
	Model newModel = 
		<
			projectView(),
			projectViewInfo,
			executionViewInfo,
			bugReportViewInfo
		>;

	newModel = tryAndParse(newModel);
	return newModel;
}

data View
	= projectView()
	| executionView()
	| bugReportView();

data Msg
  = cmChange(int fromLine, int fromCol, int toLine, int toCol, str text, str removed)
  | selectedProject(str folder)
  | selectedFile(str file)
  | saveChanges()
  | changeView(View newView)
  | setStep(int newStep)
  | setItterations(int itterations)
  | startNewAnalysis()
  | setBugType(BugType bugType)
  | inspectExecution(ExecutionArtifact executionArtifact, int currentStep)
  | generateSoundLevel();

private list[str] mySplit(str sep, str s) {
  if (/^<before:.*?><sep>/m := s) {
    return [before] + mySplit(sep, s[size(before) + size(sep)..]);
  }
  return [s];
}

private str updateSrc(str src, int fromLine, int fromCol, int toLine, int toCol, str text, str removed) {
  // NOTE: Added this for microsoft line breaks.
  str src = replaceAll(src, "\r\n", "\n");
  list[str] lines = mySplit("\n", src);

  int from = (0 | it + size(l) + 1 | str l <- lines[..fromLine] ) + fromCol;
  int to = from + size(removed);
  
  str newSrc;
  if (to < size(src))
  {
    newSrc = src[..from] + text + src[to..];
  }
  else
  {
  	newSrc = src[..from] + text;
  	
  }  
  return newSrc;
}

Model update(Msg msg, Model model) {
  switch (msg) {
  	case changeView(View newView):
  	{
  		model.view = newView;
  	}
    case cmChange(int fromLine, int fromCol, int toLine, int toCol, str text, str removed):
    {
      model.projectViewInfo.updatedSrc = updateSrc(model.projectViewInfo.updatedSrc, fromLine, fromCol, toLine, toCol, text, removed);
	  }
    case selectedProject(str folder):
    {
    	model.projectViewInfo.selectedProject = folder;
    	model.projectViewInfo.projectFiles = listEntries(projectsFolder + folder);
    	model = selectFile(model, model.projectViewInfo.projectFiles[0]);
    	
			model = tryAndParse(model);
			model.bugReportViewInfo.bugReport = emptyReport();
    }
    case selectedFile(str file):
    {
    	model = selectFile(model, file);
    	model.view = projectView();
    }
    case saveChanges():
    {
    	loc file = projectsFolder 
    		+ model.projectViewInfo.selectedProject 
    		+ model.projectViewInfo.selectedFile;
    	writeFile(file, model.projectViewInfo.updatedSrc);
    	model = tryAndParse(model);
    }
    case setStep(int newStep):
    {
    	model.executionViewInfo.currentStep = newStep;
    }
    case setItterations(int itterations):
    {
    	model.bugReportViewInfo.itterations = itterations;
    }
    case startNewAnalysis():
    {
    	model.bugReportViewInfo.bugReport 
    		= analyseProject(model.projectViewInfo.parsedProject.project, 
    			model.bugReportViewInfo.itterations);
    }
    case setBugType(BugType bugType):
    {
    	model.bugReportViewInfo.selectedBugType = bugType;
    }
    case inspectExecution(ExecutionArtifact executionArtifact, int currentStep):
    {
    	model.view = executionView();
    	model.executionViewInfo.executionArtifact = executionArtifact;
    	model.executionViewInfo.currentStep = currentStep;
    }
    case generateSoundLevel():
    {
    	model = generateSoundLevel(model);
    	model.view = executionView();
    }
  }
  return model;
}

Model tryAndParse(Model model)
{
	model.projectViewInfo.parsedProject = emptyArtifact();
  for (str file <- model.projectViewInfo.projectFiles)
	{
		if (file[-4..] == ".lsp")
		{
			loc projectFile = projectsFolder + model.projectViewInfo.selectedProject + file;
			model.projectViewInfo.parsedProject 
				= parseAndTransform(projectFile);
				
			if (size(model.projectViewInfo.parsedProject.errors) == 0)
			{
				model.projectViewInfo.prepairedProject 
					= extractModuleHierarchy(model.projectViewInfo.parsedProject.project);
					
				if (size(model.projectViewInfo.prepairedProject.errors) == 0)
				{
					model.projectViewInfo.madScores 
						= calculateMAD(model.projectViewInfo.parsedProject.project);
					model.executionViewInfo.executionArtifact 
						= executeProject(model.projectViewInfo.parsedProject.project);
				}
			}
			break;
		}
	}
	return model;
}

Model generateSoundLevel(Model model)
{
	ExecutionArtifact artifact = model.executionViewInfo.executionArtifact;
	PropertyStates finalPropertyStates = last(artifact.propertyReport.history).propertyStates;
	
	// TODO: 100 executions can take a long time. Measure time.
	for (int i <- [0 .. 100])
	{
		if (false in finalPropertyStates)
		{
			model.executionViewInfo.executionArtifact 
				= executeProject(model.projectViewInfo.parsedProject.project);
		}
		else
		{
			return model;
		}
	}
	println("Couldn\'t generate sound level");
	
	return model;
}

Model selectFile(Model model, str file)
{
	model.projectViewInfo.selectedFile = file;
	loc fileLocation = projectsFolder + model.projectViewInfo.selectedProject + file;
  model.projectViewInfo.initialSrc = readFile(fileLocation);

	str extension = file[-4..];
	switch (extension)
	{
		case ".lsp": model.projectViewInfo.mode = grammar2mode("Project", #parsing::languages::project::Syntax::Project);
		case ".alp": model.projectViewInfo.mode = grammar2mode("Alpabet", #parsing::languages::alphabet::Syntax::Alphabet);
		case ".grm": model.projectViewInfo.mode = grammar2mode("Grammar", #parsing::languages::grammar::Syntax::Grammar);
		case ".rcp": model.projectViewInfo.mode = grammar2mode("Recipe", #parsing::languages::recipe::Syntax::Recipe);
		case "sanr": model.projectViewInfo.mode = grammar2mode("LevelSpecification", #sanr::language::Syntax::LevelSpecification);
		default: println("Wrong file type");
	}
	return model;
}
