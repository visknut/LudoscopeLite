module parsing::transformations::TransformInstructions

import parsing::DataStructures;
import parsing::languages::recipe::AST;
import util::string;

public Instruction parseInstruction(iterateRule(bool commented, str ruleName))
{
	return itterateRule(removeQuotes(ruleName));
}

public Instruction parseInstruction(executeRule(bool commented, str ruleName, int executions))
{
	return executeRule(removeQuotes(ruleName), executions);
}