version: 0.6f
alphabet:
name: "Alphabet1"
position: (-243,-52)

module:
name: "AddGround"
alphabet: "Alphabet1"
position: (-120,43)
type: Recipe
match: None
grammar: true
recipe: true
showMembers: true

module:
name: "AddChallange"
alphabet: "Alphabet1"
position: (125,46)
type: Recipe
match: None
inputs: "AddDoors"
maxIterations: 10
grammar: true
recipe: true
showMembers: true

module:
name: "ClearDoors"
alphabet: "Alphabet1"
position: (243,41)
type: Recipe
match: None
inputs: "AddChallange"
grammar: true
recipe: true
showMembers: true

module:
name: "AddDoors"
alphabet: "Alphabet1"
position: (6,52)
type: Recipe
match: None
inputs: "AddGround"
grammar: true
recipe: true
showMembers: true

option: Width 6
option: Height 6
option: Tile "undefined"
