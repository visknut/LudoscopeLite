version: 0.6f
module:
name: "StartingMap"
alphabet: "Symbols"
position: (-325,91)
type: Grammar
match: None
grammar: true
showMembers: true

alphabet:
name: "Symbols"
position: (-200,-93)

module:
name: "PickMediumTemplates"
alphabet: "Symbols"
position: (-54,92)
type: Grammar
match: None
inputs: "PickLargeTemplates"
grammar: true
showMembers: true

module:
name: "PickVariables"
alphabet: "Symbols"
position: (79,92)
type: Grammar
match: None
inputs: "PickMediumTemplates"
maxIterations: 800
grammar: true
showMembers: true

module:
name: "AddVariation"
alphabet: "Symbols"
position: (189,91)
type: Recipe
match: None
inputs: "PickVariables"
grammar: true
recipe: true
showMembers: true

module:
name: "EndResult"
alphabet: "Symbols"
position: (325,91)
type: Grammar
match: None
inputs: "AddVariation"
grammar: true
showMembers: true

module:
name: "PickLargeTemplates"
alphabet: "Symbols"
position: (-204,93)
type: Recipe
match: None
inputs: "StartingMap"
maxIterations: 2
grammar: true
recipe: true
showMembers: true

option: Width 40
option: Height 20
option: Tile "Empty"
option: SplitX 5
option: SplitY 5
option: Member "Changed"
