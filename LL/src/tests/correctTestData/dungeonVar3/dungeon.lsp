version: 0.6f
alphabet:
name: "Alphabet1"
position: (-20,-106)

module:
name: "m2"
alphabet: "Alphabet1"
position: (-13,101)
type: Recipe
match: None
inputs: "m4"
grammar: true
recipe: true
showMembers: true

module:
name: "m1"
alphabet: "Alphabet1"
position: (-243,95)
type: Grammar
match: None
maxIterations: 1
grammar: true
showMembers: true

module:
name: "m3"
alphabet: "Alphabet1"
position: (116,106)
type: Recipe
match: None
inputs: "m2"
grammar: true
recipe: true
showMembers: true

module:
name: "m4"
alphabet: "Alphabet1"
position: (-129,102)
type: Recipe
match: None
inputs: "m1"
grammar: true
recipe: true
showMembers: true

option: Width 6
option: Height 6
option: Tile "floor"
