//////////////////////////////////////////////////////////////////////////////
//
// Functions for testing LL with differen map sizes.
// @brief        Functions for testing LL with differen map sizes.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         17-05-2018
//
//////////////////////////////////////////////////////////////////////////////

module experiments::MapSize

import List;
import Map;
import DateTime;
import IO;

import util::Time;
import execution::Execution;
import parsing::DataStructures;
import execution::DataStructures;

int EXECUTIONS = 100;
int MINSIZE = 2;
int MAXSIZE = 10;
RuleMap RULES = (0 : rule(reflections(false,false,false),[[0]],[[[1]]]));
LudoscopeModule MODULE = ludoscopeModule(0, [], "", [[]], RULES, [executeGrammar()]);

public void runAllExperiments()
{
	list[tuple[int, int]] averageTime = [];
	for (int i <- [MINSIZE .. MAXSIZE + 1])
	{
		averageTime += <i, timedModuleExecution(MODULE, createTileMap(i, i), EXECUTIONS)>;
	}
	iprintln(averageTime);
}

// TODO: use util version
private list[list[int]] createTileMap(int width, int height)
{
	return [[0 | int i <- [0 .. width]] | int j <- [0 .. height]];
}

private int timedModuleExecution(LudoscopeModule ludoscopeModule, 
	TileMap input, int executions)
{
	ludoscopeModule.startingState = input;
	Duration totalTime = duration(0, 0, 0, 0, 0, 0, 0);
	
	for (int i <- [0 .. executions])
	{
		datetime startTime = now();
		executeModule(ludoscopeModule, ());
		datetime endTime = now();
		
		Duration executionDuration = (endTime - startTime);
		totalTime = addDuration(totalTime, (endTime - startTime));
	}
	
	return durationToMilliseconds(totalTime)/executions;
}