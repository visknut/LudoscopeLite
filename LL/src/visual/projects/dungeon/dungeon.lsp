version: 0.6f
alphabet:
name: "Alphabet1"
position: (-15,-117)

module:
name: "m2"
alphabet: "Alphabet1"
position: (14,90)
type: Recipe
match: None
inputs: "m1"
grammar: true
recipe: true
showMembers: true

module:
name: "m1"
alphabet: "Alphabet1"
position: (-111,93)
type: Grammar
match: None
maxIterations: 1
grammar: true
showMembers: true

module:
name: "m3"
alphabet: "Alphabet1"
position: (122,94)
type: Recipe
match: None
inputs: "m2"
grammar: true
recipe: true
showMembers: true

option: Width 6
option: Height 6
option: Tile "floor"