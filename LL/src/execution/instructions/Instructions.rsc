//////////////////////////////////////////////////////////////////////////////
//
// Instructions that apply rules to the map.
// @brief        This file contains the functions for  the instructions 
//							 that apply rules.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         20-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module execution::instructions::Instructions

import IO;
import List;
import Map;

import parsing::DataStructures;
import execution::DataStructures;
import execution::instructions::Matching;

import analysis::lplWrapper::PropertyHistory;
import lpl::DataStructures;

// TODO: replace itterateRule with something that stops when tileMap doesn't change.
public ExecutionArtifact executeInstruction
(
	ExecutionArtifact artifact,
	RuleMap rules, 
	executeRule(int ruleNameIndex, int itterations))
{
	for (int i <- [0 .. itterations])
	{
		artifact = executeInstruction(artifact, rules, itterateRule(ruleNameIndex));
	}
	return artifact;
}

public ExecutionArtifact executeInstruction
(
	ExecutionArtifact artifact,
	RuleMap rules, 
	itterateRule(int ruleNameIndex)
)
{
	Rule rule = rules[ruleNameIndex];
	list[Coordinates] matches = 
		findPatternInGrid(artifact.currentState, rule.leftHand);

	if (size(matches) > 0)
	{
		Coordinates match = getOneFrom(matches);
		TileMap replacement = getOneFrom(rule.rightHands);
		
		RuleExecution ruleExecution = 
			ruleExecution(ruleNameIndex, indexOf(rule.rightHands, replacement), match);
		artifact.history[0].instructions[0].rules = 
			push(ruleExecution, artifact.history[0].instructions[0].rules);

		int patternWidth = size(rule.leftHand[0]);
		int patternHeight = size(rule.leftHand);
		
		for (int i <- [0 .. patternWidth])
		{
			for (int j <- [0 .. patternHeight])
			{
				artifact.currentState[j + match.y][i + match.x] = 
					replacement[j][i];
			}
		}
		
		/* Update property report. */ //#NULL
		artifact.propertyReport.history += updatePropertyReport(artifact);
	}
	return artifact;
}

public ExecutionArtifact executeInstruction
(
	ExecutionArtifact artifact,
	RuleMap rules, 
	executeGrammar()
)
{
	RuleMap currentRules = rules;
	while (true)
	{
		int ruleNameIndex = getOneFrom(currentRules);
		TileMap oldTileMap = artifact.currentState;
		artifact = executeInstruction(artifact, rules, itterateRule(ruleNameIndex));
		if (oldTileMap == artifact.currentState)
		{
			currentRules = delete(currentRules, ruleNameIndex);
		}
		else
		{
			currentRules = rules;
		}
		
		if (currentRules == ())
		{
			break;
		}
	}
	return artifact;
}

