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

import utility::TileMap;

import parsing::DataStructures;
import execution::DataStructures;
import execution::instructions::Matching;

import analysis::sanrWrapper::PropertyHistory;
import sanr::DataStructures;

// TODO: replace itterateRule with something that stops when tileMap doesn't change.
public ExecutionArtifact executeInstruction
(
	ExecutionArtifact artifact,
	RuleMap rules, 
	executeRule(str ruleName, int itterations))
{
	for (int i <- [0 .. itterations])
	{
		artifact = executeInstruction(artifact, rules, itterateRule(ruleName));
	}
	return artifact;
}

public ExecutionArtifact executeInstruction
(
	ExecutionArtifact artifact,
	RuleMap rules, 
	itterateRule(str ruleName)
)
{
	Rule rule = rules[ruleName];
	lrel[Coordinates, Transformations] matches = 
		findPatternWithTransformations(artifact.currentState, rule);

	if (size(matches) > 0)
	{
		tuple[Coordinates c, Transformations t] match = getOneFrom(matches);
		TileMap replacement = getOneFrom(rule.rightHands);
		replacement =	applyTransformation(match.t, replacement);
		
		// TODO: Also store transformation.
		RuleExecution ruleExecution = 
			ruleExecution(ruleName, indexOf(rule.rightHands, replacement), match.c);
		artifact.history[0].instructions[0].rules = 
			push(ruleExecution, artifact.history[0].instructions[0].rules);

		int patternWidth = size(replacement[0]);
		int patternHeight = size(replacement);
		
		for (int i <- [0 .. patternWidth])
		{
			for (int j <- [0 .. patternHeight])
			{
				artifact.currentState[j + match.c.y][i + match.c.x] = 
					replacement[j][i];
			}
		}
		
		/* Update property report. */
		artifact.propertyReport = updatePropertyReport(artifact);
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
	while (size(currentRules) > 0)
	{
		str ruleName = getOneFrom(currentRules);
		TileMap oldTileMap = artifact.currentState;
		artifact = executeInstruction(artifact, rules, itterateRule(ruleName));
		if (oldTileMap == artifact.currentState)
		{
			currentRules = delete(currentRules, ruleName);
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

