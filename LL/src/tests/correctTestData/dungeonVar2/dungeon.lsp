version: 0.6f
alphabet:
name: "Alphabet1"
position: (-82,-106)

module:
name: "m2"
alphabet: "Alphabet1"
position: (-54,102)
type: Recipe
match: None
inputs: "m1"
grammar: true
recipe: true
showMembers: true

module:
name: "m1"
alphabet: "Alphabet1"
position: (-178,104)
type: Grammar
match: None
maxIterations: 1
grammar: true
showMembers: true

module:
name: "m3"
alphabet: "Alphabet1"
position: (54,106)
type: Recipe
match: None
inputs: "m2"
grammar: true
recipe: true
showMembers: true

module:
name: "m4"
alphabet: "Alphabet1"
position: (178,100)
type: Grammar
match: None
inputs: "m3"
grammar: true
showMembers: true

option: Width 6
option: Height 6
option: Tile "floor"
