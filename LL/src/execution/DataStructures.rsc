module execution::DataStructures

import parsing::DataStructures;
import errors::Execution;

alias OutputMap = map[str, TileMap];

data ExecutionArtifact =
	executionArtifact(OutputMap output, list[ExecutionError] errors);