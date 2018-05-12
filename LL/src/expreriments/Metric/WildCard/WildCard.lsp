version: 0.6f
alphabet:
name: "Alphabet1"
position: (-98,-49)

module:
name: "AddGround"
alphabet: "Alphabet1"
position: (-130,46)
type: Grammar
match: None
grammar: true
showMembers: true

module:
name: "AddEnvoirment"
alphabet: "Alphabet1"
position: (-8,49)
type: Grammar
match: None
inputs: "AddGround"
grammar: true
showMembers: true

module:
name: "AddVillage"
alphabet: "Alphabet1"
position: (130,47)
type: Grammar
match: None
inputs: "AddEnvoirment"
maxIterations: 1
grammar: true
showMembers: true

