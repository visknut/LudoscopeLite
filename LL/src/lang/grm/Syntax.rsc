module lang::grm::Syntax
import ParseTree;

start syntax GRM
	= grm: "version" ":" NAME Start Rule*;
	
syntax Start
  = startmap: "start" ":" MAPTYPE VALUE VALUE Tile*;
  
syntax Rule
	= rule: "rule" ":" IDENTIFIER Settings? "=" Righthand "\>" Lefthand+;
	
syntax Righthand
	= righthand: MAPTYPE VALUE VALUE Tile*;
	
syntax Lefthand
	= lefthand: "{" VALUE Expression? "=" MAPTYPE VALUE VALUE Tile* "}";
	
syntax Settings
	= settings: "(" ("width" "=" VALUE)? ("height" "=" VALUE)? ("gt" "=" VALUE)? ")";
  
syntax Tile
	= tile: VALUE ":" IDENTIFIER Expression?;
	
syntax Expression
  = expression: "(" STRING ")"; // TODO: implement expressions.

syntax String
  = @category="String"  "\"" STRING "\""; // TODO: How to clean \" form the string in parser?
    
syntax MAPTYPE
  = maptype: "TILEMAP"; // TODO: accept multiple map types.

syntax IDENTIFIER
  = indentifier: NAME;

lexical NAME
  = ([a-zA-Z0-9_$.*] [a-zA-Z0-9_$.*]* !>> [a-zA-Z0-9_$.*]) \ Keyword;

lexical COLORCODE
	= "#" [0-9A-Z]*;
 
lexical VALUE
  = @category="Value" ("-"?[0-9]+([.][0-9]+?)?); // TODO: Meaning @category?
  
lexical STRING
  = ![\"]*;

layout LAYOUTLIST
  = LAYOUT* !>> [\t-\n \r \ , |];

lexical LAYOUT
  =  [\t-\n \r \ : , { } ( ) \> = |];
  
keyword Keyword
  = "version"
  | "start"
  | "rule"
  | "TILEMAP"
  | "width"
  | "height"
  | "gt";
  
public start[GRM] grm_parse(loc file) = 
  parse(#start[GRM], file);
  
public start[GRM] grm_parse_test() = 
   grm_parse(|project://LL/src/lang/testdate/grammarNoExpressions.grm|);