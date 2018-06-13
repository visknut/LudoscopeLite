module visual::DataStructures

import parsing::DataStructures;
//import sanr::DataStructures;

alias Symbol = tuple[str name, str fill, str colour];
alias SymbolMap = list[list[Symbol]];
alias History = list[SymbolMap];
alias Location = tuple[int x, int y];
alias LevelProperties = list[str property];

//void transformPorpertyReport(PropertyReport report, Alphabet)
//{
//	
//}