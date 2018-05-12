version: 0.6f
alphabet:
name: "Alphabet1"
position: (-130,-49)

module:
name: "AddGround"
alphabet: "Alphabet1"
position: (-162,46)
type: Grammar
match: None
grammar: true
showMembers: true

module:
name: "AddEnvoirment"
alphabet: "Alphabet1"
position: (-40,49)
type: Grammar
match: None
inputs: "AddGround"
grammar: true
showMembers: true

module:
name: "AddBridge"
alphabet: "Alphabet1"
position: (97,47)
type: Grammar
match: None
inputs: "AddEnvoirment"
maxIterations: 1
grammar: true
showMembers: true

