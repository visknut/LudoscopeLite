module parsing::dataStructures

// TODO: add registers & options
data LudoscopeProject
	= ludoscopeProject(list[LudoscopeModule] modules, list[map[str, int]] alphabets);
	
data LudoscopeModule
	= ludoscopeModule(LudoscopeModule input, list[list[int]] startingState, list[Rule] rules, list[Instruction] recipe);
	
data Rule
	= rule(int width, int height, bool rotateHorizontal, bool rotateVertical, list[list[int]] leftHand, list[list[int]] rightHands);
	
data Instruction
	= itterateRule(Rule rule)
	| executeRule(Rule rule, int itterations);