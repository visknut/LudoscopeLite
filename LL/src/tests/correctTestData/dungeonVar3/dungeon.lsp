version: 0.6f
alphabet:
name: "Alphabet1"
position: (44,-106)

module:
name: "m2"
alphabet: "Alphabet1"
position: (50,101)
type: Recipe
match: None
inputs: "m4"
grammar: true
recipe: true
showMembers: true

module:
name: "m1"
alphabet: "Alphabet1"
position: (-180,95)
type: Grammar
match: None
maxIterations: 1
grammar: true
showMembers: true

module:
name: "m3"
alphabet: "Alphabet1"
position: (180,106)
type: Recipe
match: None
inputs: "m2"
grammar: true
recipe: true
showMembers: true

module:
name: "m4"
alphabet: "Alphabet1"
position: (-66,102)
type: Recipe
match: None
inputs: "m1"
grammar: true
recipe: true
showMembers: true

option: Width 6
option: Height 6
option: Tile "floor"
