@license{
  Copyright (c) Tijs van der Storm <Centrum Wiskunde & Informatica>.
  All rights reserved.
  This file is licensed under the BSD 2-Clause License, which accompanies this project
  and is available under https://opensource.org/licenses/BSD-2-Clause.
}
@contributor{Tijs van der Storm - storm@cwi.nl - CWI}

module visual::History

import salix::App;
import salix::HTML;
import salix::SVG;
import salix::Core;

import visual::DataStructures;

import String;
import IO;
import List;

//////////////////////////////////////////////////////////////////////////////
// Data.
//////////////////////////////////////////////////////////////////////////////

alias Model = tuple[int step, History history, Location focus];

data Msg
  = inc()
  | dec()
  | setStep(int newStep)
  | newHistory(History history)
  | changeFocus(Location focus);

//////////////////////////////////////////////////////////////////////////////
// Initialization.
//////////////////////////////////////////////////////////////////////////////

App[Model] LLAPP()
  = app(init, 
  			view, 
  			update, 
  			|http://localhost:9101/LudoscopeLite/LL/src/visual/index.html|, 
  			|project://LL%20project|);

Model init() = 
	<
	0,
	[
		[[<"Tile 1", "#000000", "#555555">, <"Tile 2", "#555555", "#000000">],
		[<"Tile 2", "#555555", "#000000">, <"Tile 1", "#000000", "#555555">]]
		,
		[[<"Tile 1", "#000000", "#555555">, <"Tile 1", "#000000", "#555555">],
		[<"Tile 2", "#555555", "#000000">, <"Tile 1", "#000000", "#555555">]]
		,
		[[<"Tile 1", "#000000", "#555555">, <"Tile 1", "#000000", "#555555">],
		[<"Tile 1", "#000000", "#555555">, <"Tile 1", "#000000", "#555555">]]
 	],
 	<0, 0>
 	>;

//////////////////////////////////////////////////////////////////////////////
// Updating the model.
//////////////////////////////////////////////////////////////////////////////

Model update(Msg msg, Model model) {
  switch (msg) {
    case inc(): 
    {
    	if (model.step + 1 != size(model.history))
    	{
    		 model.step += 1;
    	}
    }
    case dec():
    {
    	if (model.step - 1 != -1)
    	{
    		 model.step -= 1;
    	}
    }
    case setStep(int newStep):
    {
    	if (newStep > -1 && newStep < size(model.history))
    	{
    		 model.step = newStep;
    	}
    }
    case newHistory(History history): model.history = history;
    case changeFocus(Location focus) : model.focus =  focus; 
  }
  return model;
}

//////////////////////////////////////////////////////////////////////////////
// Drawing the view.
//////////////////////////////////////////////////////////////////////////////

void view(Model model) {
  div(() {
    viewMap(model);
    viewFocus(model);
    
    h2("Scroll through history");
    
    button(onClick(inc()), "+");
    
    p(() {
      text("step: ");
      input(
      	\value("<model.step>"),
      	\type("range"), 
      	\min("0"),
      	\max("<size(model.history) - 1>"), 
      	onInput(setStep));
    });
    
    button(onClick(dec()), "-");

  });
}

void viewFocus(Model model)
{
	int x = model.focus.x;
	int y = model.focus.y;
	SymbolMap currentMap = model.history[model.step];
	Symbol focus = currentMap[y][x];
	div(() {
			h2("Focus:");
			_text("Location: (<x>, <y>)");
			_text("Name: <focus.name>");
	});
}

void viewMap(Model model) {
  svg(viewBox("0 0 100 100"), width("300px"), () {
  	SymbolMap currentMap = model.history[model.step];
  	for (int row <- [0 .. size(currentMap)])
  	{
  		for (int column <- [0 .. size(currentMap[0])])
  		{
  			Symbol symbol = currentMap[row][column];
  			rect(
  				x("<row * 10 + 0.5>"), 
				 	y("<column * 10 + 0.5>"), 
				 	width("9.5"), 
				 	height("9.5"), 
				 	fill(symbol.fill), 
				 	stroke(symbol.colour), 
				 	strokeWidth("0.5"), 
				 	onMouseOver(changeFocus(<column, row>)));
  			if (model.focus == <column, row>)
  			{
  				circle(
  					cx("<row * 10 + 5.25>"), 
  					cy("<column * 10 + 5.25>"),
  					r("2"),
  					fill("#FFFFFF"),
  					fillOpacity("0.4"));
  			}
  		}
  	}
  });
}

