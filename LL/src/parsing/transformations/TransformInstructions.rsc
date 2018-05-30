//////////////////////////////////////////////////////////////////////////////
//
// Transform Instructions
// @brief        Functions that replace the AST constructor with a new
//               constructor from DataStructures.rsc.
// @contributor  Quinten Heijn - samuel.heijn@gmail.com - UvA
// @date         23-04-2018
//
//////////////////////////////////////////////////////////////////////////////

module parsing::transformations::TransformInstructions

import List;
import parsing::DataStructures;
import parsing::languages::recipe::AST;
import util::string;

public Instruction parseInstruction
(
	TransformationArtifact artifact,
	iterateRule(bool commented, str ruleName)
)
{
	return itterateRule(removeQuotes(ruleName));
}

public Instruction parseInstruction
(
	TransformationArtifact artifact,
	executeRule(bool commented, str ruleName, int executions)
)
{
	return executeRule(removeQuotes(ruleName), executions);
}