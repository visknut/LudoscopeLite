module parsing::lang::rcp::Syntax
import ParseTree;

start syntax RCP
  = rcp: Commands*;
  
syntax Commands
  = setRegister: 			"SetRegister" "(" String VALUE ")" // TODO: registers can hold mutiple values, including expressions.
  | iterateRule: 			"IterateRule" "(" String ")"
  | iterateFromRegister: 	"IterateFromRegister" "(" String ")"
  | iterateRuleLSystem:		"IterateRuleLSystem" "(" String ")"
  | iterateRuleCellular: 	"IterateRuleCellular" "(" String ")"
  | executeFromRegister: 	"ExecuteFromRegister" "(" String VALUE")" // TODO: executions can also use the 'D' notation. (for example 'D2')
  | executeRuleLSystem: 	"ExecuteRuleLSystem" "(" String VALUE")"
  | executeRuleCellular: 	"ExecuteRuleCellular" "(" String VALUE")"
  | executeRule: 			"ExecuteRule" "(" String VALUE")"
  | splitTiles: 			"SplitTiles" "(" VALUE VALUE ")"
  | replaceLabels: 			"ReplaceLabels" "(" String String")"
  | keepTopOfStack: 		"KeepTopOfStack"
  | createTileMap: 			"CreateTileMap" "(" NAME NAME String ")"; // TODO: it should probably also be possible to use integers.
  
//  | transformSymbols: 		"TransformSymbols" "(" ")"

syntax IDENTIFIER
  = indentifier: NAME;

lexical NAME
  = ([a-zA-Z_$] [a-zA-Z0-9_$]* !>> [a-zA-Z0-9_$]) \ Keyword;

// TODO: the use of wildcards is possible in the use of rulenames.
syntax String
  = @category="String"  "\"" STRING "\""; // TODO: How to clean \" form the string in parser?

lexical VALUE
  = @category="Value" ("-"?[0-9]+([.][0-9]+?)?); // TODO: Meaning @category?

lexical STRING
  = ![\"]*;

layout LAYOUTLIST
  = LAYOUT* !>> [\t-\n \r \ : ,];

lexical LAYOUT
  =  [\t-\n \r \ : ,];
  
keyword Keyword
  = "SetRegister"
  | "IterateRule"
  | "IterateFromRegister"
  | "IterateRuleLSystem"
  | "IterateRuleCellular"
  | "ExecuteFromRegister"
  | "ExecuteRuleLSystem"
  | "ExecuteRuleCellular"
  | "ExecuteRule"
  | "ReplaceLabels"
  | "SplitTiles"
  | "TransformSymbols"
  | "CreateTileMap"
  | "KeepTopOfStack";
  
public start[RCP] rcp_parse(loc file) = 
  parse(#start[RCP], file);
  
public start[RCP] rcp_parse_test() = 
   rcp_parse(|project://LL/src/lang/testdate/simpleRecipe.rcp|);