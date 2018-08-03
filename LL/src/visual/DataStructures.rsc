module visual::DataStructures

import parsing::DataStructures;
//import sanr::DataStructures;
import parsing::languages::alphabet::AST;

alias SymbolMap = list[list[Symbol]];
alias History = list[SymbolMap];
alias Location = tuple[int x, int y];
alias LevelProperties = list[str property];

alias History = list[Step];