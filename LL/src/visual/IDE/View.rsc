module visual::IDE::View

import visual::IDE::IDE;

/* Prelude */
import IO;
import String;
import List;
import Map;

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
import analysis::sanrWrapper::PropertyToText;
import sanr::language::AST;
import sanr::DataStructures;
import analysis::sanrWrapper::Report;

public void view(Model model) {
  div(() {
  	viewHeader(model);
    
    switch (model.view)
    {
    	case projectView(): viewProject(model);
    	case executionView(): viewExecution(model);
    	case bugReportView(): viewBugReport(model);
    }

		viewFooter(model);
  });
}

void viewBugReport(Model model)
{
	div(class("container"), () {
		if (model.executionViewInfo.executionArtifact == emptyExecutionArtifact())
		{
			h3("The project stil contains parsing errors..");
		} 
		else
		{
			div(class("row"), () {
				int itterations = model.bugReportViewInfo.itterations;
				input(\value("<itterations>"),\type("number"), min("1"), max("10000"), onInput(setItterations));
				button(onClick(startNewAnalysis()), "Start analysis");
			});
			
			Report report = model.bugReportViewInfo.bugReport;
			
			if (report != emptyReport())
			{
				div(class("row"), () {
					int actualItterations = 0;
					for (key <- report.outputs)
					{
						actualItterations += report.outputs[key];
					}
	
					div(class("col-md-3"), () {
			
						h3("Executions: <actualItterations>");
						h3("Unique results: <size(report.outputs)>");
						h3("Broken results: <report.brokenOutputs>");
					});

					div(class("col-md-6 scrollBox"), () {
						table(class("table table-hover table-condensed"), () {
						thead(() {
							th(scope("col"), () {
								text("Property");
							});
							th(scope("col"), () {
								text("Broken By");
							});
							th(scope("col"), () {
								text("Occurences");
							});
						});
						tbody(() {
							for(BugType bugType <- report.bugTypes)
							{
								list[Bug] bugs = report.bugs[bugType];
								real percentage = ((1.0*size(bugs))/actualItterations) * 100.0;
								if (bugType == model.bugReportViewInfo.selectedBugType)
								{
									tr(class("active"), onClick(setBugType(emptyBugType())), () {
										th(scope("row"), () {
											text(propertyToText(bugType.property));
										});
										th(scope("row"), () {
											text(bugType.rule);
										});
										th(scope("row"), () {
											text("<size(bugs)> (<percentage>%)");
										});
									});
									for (Bug bug <- bugs)
									{
										tr(class("warning"), onClick(inspectExecution(bug.execution, bug.step)), () {
											th(scope("row"), () {
												text("↳		Execution #<bug.executionNumber>");
											});
											th(scope("row"), () {
											});
											th(scope("row"), () {
											});
										});
									}
								}
								else
								{
									tr(onClick(setBugType(bugType)), () {
										th(scope("row"), () {
											text(propertyToText(bugType.property));
										});
										th(scope("row"), () {
											text(bugType.rule);
										});
										th(scope("row"), () {
											text("<size(bugs)> (<percentage>%)");
										});
									});
								}
							}
						});
					});
				});
				});
			}
		}
	});
}

void viewExecution(model)
{
	if (model.executionViewInfo.executionArtifact == emptyExecutionArtifact())
	{
		h3("The project stil contains parsing errors..");
	} 
	else
	{
		ExecutionHistory history = model.executionViewInfo.executionArtifact.history;
		
		div(class("container"), () {
			div(class("row"), () {
				/* History */
				viewHistory(model);
				/* Pipeline, maps, rule */
				div(class("col-md-6"), () {
					Step step = history[model.executionViewInfo.currentStep];
				
					LudoscopeProject project = model.projectViewInfo.parsedProject.project;
				
					LudoscopeModule \module = [\module | 
						LudoscopeModule \module <- project.modules,
						\module.name == step.moduleName][0];
	
					Alphabet alphabet = project.alphabets[\module.alphabetName];
					
					/* Pipeline */
					div(class("row"), () {
						//viewPipeline(model);
					});
					
					/* Maps */
					TileMap tileMap = step.tileMap;	
					int svgWidth = 300;
					int svgHeight 
						= calculateSvgHeight(svgWidth, size(tileMap[0]), size(tileMap));
					
					div(class("row svgWrapper text-center"), style(<"height", "<svgHeight>px;">), () {				
						SymbolMap symbolMap = TileMapToSymbolMap(tileMap, alphabet);
						
						drawSymbolMap(symbolMap, svgWidth);
					});
					hr();
					/* Rule */
					div(class("row ruleRow"), () {
						Rule rule = \module.rules[step.ruleName];
						list[RightHandScore] madScores 
							= model.projectViewInfo.madScores[\module.name][step.ruleName];
						
						drawRule(alphabet, rule, madScores);
					});
				});
				/* Properties */
				PropertyReport propertyReport 
					= model.executionViewInfo.executionArtifact.propertyReport;
				list[Property] properties = propertyReport.specification.properties;
				PropertyStates propertyStates 
					= propertyReport.history[1 + model.executionViewInfo.currentStep].propertyStates;
				
				div(class("col-md-3"), () {
					h3("Properties");
					table(class("table table-condensed"), () {
						tbody(() {
							for(int i <- [0 .. size(properties)])
							{
								Property property = properties[i];
								str rowClass;
								if (propertyStates[i])
								{
									rowClass = "success";
								}
								else
								{
									rowClass = "danger";
								}
								tr(class(rowClass), () {
									th(scope("row"), () {
										text(propertyToText(property));
									});
								});
							}
						});
					});
				});
			});
		});
	}
}

void viewHistory(Model model)
{
	ExecutionHistory history = model.executionViewInfo.executionArtifact.history;
	div(class("col-md-3 executionHistory"), () {
		table(class("table table-hover table-condensed"), () {
			thead(() {
				th(scope("col"), class("text-center"), () {
					text("#");
				});
				th(scope("col"), class("text-center"), () {
					text("Module");
				});
				th(scope("col"), class("text-center"), () {
					text("Instruction");
				});
				th(scope("col"), class("text-center"), () {
					text("Rule");
				});
			});
			tbody(() {
				for(int i <- [0 .. size(history)])
				{
					Step step = history[i];
					str rowClass = "";
					if (i == model.executionViewInfo.currentStep)
					{
						rowClass = "active";
					}
					tr(class(rowClass), onClick(setStep(i)), () {
						th(scope("row"), () {
							text("<i>");
						});
						th(scope("row"), () {
							text(step.moduleName);
						});
						th(scope("row"), () {
							text(step.instruction);
						});
						th(scope("row"), () {
							text(step.ruleName);
						});
					});
				}
			});
		});
	});
}

void viewProject(Model model)
{
  div(class("container"), () {
    div(class("row"), () {
      div(class("col-md-6"), () {
	      codeMirrorWithMode("cm", model.projectViewInfo.mode, onChange(cmChange), style(("height": "500")),
	        lineNumbers(true), \value(model.projectViewInfo.initialSrc), lineWrapping(true), class("cm-s-3024-night"));

		    button(onClick(saveChanges()), "Save changes");
		  });
			div(class("col-md-6"), () {
				if (model.projectViewInfo.parsedProject == emptyArtifact())
				{
					h3("No project to parse..");
				}
				else if (size(model.projectViewInfo.parsedProject.errors) > 0)
				{
					for (ParsingError error <- model.projectViewInfo.parsedProject.errors)
					{
						h4(errorToString(error));
					}
				}
				else if (size(model.projectViewInfo.prepairedProject.errors) > 0)
				{
					for (ExecutionError error <- model.projectViewInfo.prepairedProject.errors)
					{
						h4(errorToString(error));
					}
				}
				else
				{
					str extension = model.projectViewInfo.selectedFile[-4..];
					switch (extension)
					{
						case ".lsp": viewPipeline(model);
						case ".alp": viewAlphabet(model);
						case ".grm": viewGrammar(model);
						case ".rcp": viewGrammar(model);
						case ".snr": viewPipeline(model);
						default: viewPipeline(model);
					}

				}
			});
    });
  });
}

void viewPipeline(Model model)
{
	rel[str, str] graph = {};
	for (int i <- [1 .. size(model.projectViewInfo.prepairedProject.hierarchy)])
	{
		set[LudoscopeModule] modules = model.projectViewInfo.prepairedProject.hierarchy[i-1];
		set[LudoscopeModule] higherModules = model.projectViewInfo.prepairedProject.hierarchy[i];
		
		graph += {<"<\module.name>", "<higherModule.name>"> | 
			LudoscopeModule \module <- modules, 
			LudoscopeModule higherModule <- higherModules};
	}
	 
	dagre("pipeline", rankdir("LR"), width(500), height(500), marginx(100), marginy(100), (N n, E e) {
	    for (str x <- graph<0> + graph<1>) {
	      n(x, shape("circle"), () {
	      	div(() {
	      		a(class("moduleLink"), href("#"), onClick(selectedFile(x + ".grm")), x);
	        });
	      });
	    }
	    for (<str x, str y> <- graph) {
	      e(x, y, lineInterpolate("cardinal"));
	    }
	});
}

void viewGrammar(Model model)
{
	str moduleName = model.projectViewInfo.selectedFile[..-4];
	LudoscopeModule \module = [\module | 
		LudoscopeModule \module <- model.projectViewInfo.parsedProject.project.modules,
		\module.name == moduleName][0];
	
	Alphabet alphabet = 
		model.projectViewInfo.parsedProject.project.alphabets[\module.alphabetName];
	div(class("scrollBox container col-md-12"), () {
	
		if (\module.recipe == [executeGrammar()])
		{
			div(class("row"), () {
		  	h3(\module.name);
				h4("Executed as grammar");
			});
			hr();
			for (str ruleName <- \module.rules)
			{
				Rule rule = \module.rules[ruleName];
	    	div(class("row"), () {
		  		h4(ruleName);
		  	});
				drawRule(alphabet, rule, model.projectViewInfo.madScores[\module.name][ruleName]);
				hr();
			}
		}
		else
		{
			div(class("row"), () {
		  	h3(\module.name);
				h5("Executed as recipe");
				hr();
			});
			for (Instruction instruction <- \module.recipe)
			{
				int execution;
				if (/itterateRule(A) := instruction)
				{
					execution = 1;
				}
				else
				{
					execution = instruction.itterations;
				}
				str ruleName = instruction.ruleName;
				Rule rule = \module.rules[ruleName];
	    	div(class("row"), () {
		  		h4("<ruleName> (<execution>x)");
		  	});
				drawRule(alphabet, rule, model.projectViewInfo.madScores[\module.name][ruleName]);
				hr();
			}
		}
	});
}

void drawRule(Alphabet alphabet, Rule rule, list[RightHandScore] madScores)
{
	int svgWidth = 100;
	int svgHeight 
		= calculateSvgHeight(svgWidth, size(rule.leftHand[0]), size(rule.leftHand));
	div(class("row"), () {
  	div(class("col-md-4 svgWrapper text-center"), style(<"height", "<svgHeight>px;">), () {
  		SymbolMap symbolMap = TileMapToSymbolMap(rule.leftHand, alphabet);
  		drawSymbolMap(symbolMap, svgWidth);
  	});
  	div(class("col-md-2 arrow"), () {
  		text("➞");
  	});
		div(class("col-md-4 svgWrapper text-center"), style(<"height", "<svgHeight>px;">), () {
			SymbolMap symbolMap = TileMapToSymbolMap(rule.rightHands[0], alphabet);
  		drawSymbolMap(symbolMap, svgWidth);
		});
		div(class("col-md-1"), () {
			viewOptionsRule(rule.reflections, madScores[0].score);
		});
	});
}

int calculateSvgHeight(int width, int tilesWidth, int tilesHeight) {
	int tileWidth = width / tilesWidth;
	if (tileWidth == width)
	{
		tileWidth = width /2;
	}
	return tileWidth * tilesHeight;
}

void drawSymbolMap(SymbolMap symbolMap, int svgWidth)
{
	int tileWidth = svgWidth / size(symbolMap[0]);
	if (tileWidth == svgWidth)
	{
		tileWidth = svgWidth /2;
	}
	int svgHeight = tileWidth * size(symbolMap);
	
	svg(height("<svgHeight>px"), width("<svgWidth>px"), () {		
		for (int row <- [0 .. size(symbolMap)])
		{
			for (int column <- [0 .. size(symbolMap[0])])
			{
				SymbolInfo symbol = symbolMap[row][column];
				rect(
					x("<column * tileWidth>"), 
				 	y("<row * tileWidth>"), 
				 	width("<tileWidth - 1>"), 
				 	height("<tileWidth - 1>"),
				 	fill(symbol.fill), 
				 	stroke(symbol.color), 
				 	strokeWidth("0.5"));
				 	//onMouseOver(changeFocus(<column, row>)));
			}
		}
	});
}

SymbolMap TileMapToSymbolMap(TileMap tileMap, Alphabet alphabet)
{
	return [[getSymbol(alphabet, tile) | str tile <- row] | list[str] row <- tileMap];
}

SymbolInfo getSymbol(Alphabet alphabet, str symbolName)
{ 
	return head([symbol | SymbolInfo symbol <- alphabet.symbols, symbol.name == symbolName]);
}

void viewOptionsRule(Reflections reflections, int madScore)
{
	div(class("row"), () {
		if (reflections.mirrorHorizontal)
		{
			div(class("optionOn"), () {
				text("H");
			});
		}
		else
		{
			div(class("optionOff"), () {
				text("H");
			});
		}
	});
	div(class("row"), () {
		if (reflections.mirrorVertical)
		{
			div(class("optionOn"), () {
				text("V");
			});
		}
		else
		{
			div(class("optionOff"), () {
				text("V");
			});
		}
	});
	div(class("row"), () {
		if (reflections.rotate)
		{
			div(class("optionOn"), () {
				text("R");
			});
		}
		else
		{
			div(class("optionOff"), () {
				text("R");
			});
		}
	});
	div(class("row"), () {
		if (madScore < 0)
		{
			div(class("negativeMAD"), () {
				text("<madScore>");
			});
		}
		else
		{
			div(class("positiveMAD"), () {
				text("<madScore>");
			});
		}
	});
}

void viewAlphabet(Model model)
{
	str alphabetName = model.projectViewInfo.selectedFile[..-4];
	Alphabet alphabet = 
		model.projectViewInfo.parsedProject.project.alphabets[alphabetName];
	div(class("scrollBox container col-md-12"), () {
		for (SymbolInfo symbol <- alphabet.symbols)
		{
			div(class("row"), () {
				div(class("col-md-1"), () {
					svg(height("30px"), width("30px"), () {
						rect(
							x("0"), 
						 	y("0"), 
						 	width("30"), 
						 	height("30"),
						 	fill(symbol.fill), 
						 	stroke(symbol.color),
						 	strokeWidth("1"));
					});
				});
				div(class("col-md-2"), () {
					h4(symbol.name);
				});
			});
		}
	});
}

void viewHeader(Model model) {
	header(() {
		nav(class("navbar navbar-inverse navbar-static-top"), () {
			a(class("navbar-brand"), href("#"), () {
				text("Ludoscope Lite");
			});
			ul(class("nav navbar-nav"), () {
				li(class("dropdown"), () {
					a(class("dropdown-toggle"), datatoggle("dropdown"), href("#"), () {
						text("Project");
						span(class("caret"), () {});
					});
					ul(class("dropdown-menu"), () {
						for (str project <- model.projectViewInfo.projects)
						{
							if (project == model.projectViewInfo.selectedProject)
							{
							  li(class("active"), () {
									a(href("#"), onClick(selectedProject(project)), project);
								});
							}
							else
							{
							  li(() {
									a(href("#"), onClick(selectedProject(project)), project);
								});
							}
						}
					});
				});
				li(class("dropdown"), () {
					a(class("dropdown-toggle"), datatoggle("dropdown"), href("#"), () {
						text("File");
						span(class("caret"), () {});
					});
					ul(class("dropdown-menu"), () {
						for (str file <- model.projectViewInfo.projectFiles)
						{
							if (file == model.projectViewInfo.selectedFile)
							{
							  li(class("active"), () {
									a(href("#"), onClick(selectedFile(file)), file);
								});
							}
							else
							{
							  li(() {
									a(href("#"), onClick(selectedFile(file)), file);
								});
							}
						}
					});
				});
				li(class("dropdown"), () {
					a(class("dropdown-toggle"), datatoggle("dropdown"), href("#"), () {
						text("Execute");
						span(class("caret"), () {});
					});
					ul(class("dropdown-menu"), () {
					  li(() {
							a(href("#"), onClick(changeView(executionView())), "Execute project");
						});
						li(() {
							a(href("#"), onClick(generateSoundLevel()), "Generate sound level");
						});
						li(() {
							a(href("#"), onClick(changeView(bugReportView())), "SaNR analysis");
						});
					});
				});
			});
		});
	});
}

void viewFooter(Model model)
{
  footer(class("footer"), () {
  	div(class("container"), () {
  		span(class("text-muted"), () {
  			text("Powered by: Rascal & Salix");
  		});
  	});
  });
}