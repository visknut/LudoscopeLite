version: 0.6f
alphabet:
name: "Alphabet1"
position: (-238,-51)

module:
name: "AddGround"
alphabet: "Alphabet1"
position: (-130,46)
type: Grammar
match: None
grammar: true
showMembers: true

module:
name: "AddFurniture"
alphabet: "Alphabet1"
position: (130,47)
type: Grammar
match: None
inputs: "AddWalls"
maxIterations: 10
grammar: true
showMembers: true

module:
name: "AddWalls"
alphabet: "Alphabet1"
position: (-8,49)
type: Grammar
match: None
inputs: "AddGround"
grammar: true
showMembers: true

module:
name: "ClearDoors"
alphabet: "Alphabet1"
position: (248,42)
type: Grammar
match: None
inputs: "AddFurniture"
grammar: true
showMembers: true

