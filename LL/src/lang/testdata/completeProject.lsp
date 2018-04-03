module:
name: "Start"
alphabet: "MapTiles"
position: (-237,38)
type: Recipe
match: None
grammar: true
recipe: true
showMembers: true

module:
name: "AddRequests"
alphabet: "MapTiles"
position: (-149,38)
type: Recipe
match: None
inputs: "Start"
grammar: true
recipe: true
showMembers: true

module:
name: "DoDecoration"
alphabet: "MapTiles"
position: (142,42)
type: Recipe
match: None
inputs: "CombineTerrain"
grammar: true
executionType: Cellular
recipe: true
showMembers: true

module:
name: "Enlarge"
alphabet: "MapTiles"
position: (-37,40)
type: Recipe
match: None
inputs: "AddRequests"
maxIterations: 2
grammar: true
executionType: LSystem
recipe: true
showMembers: true

module:
name: "CombineTerrain"
alphabet: "MapTiles"
position: (73,36)
type: Recipe
match: StackTiles
inputs: "Enlarge"
grammar: true
executionType: LSystem
recipe: true
showMembers: true

module:
name: "SeedTerrain"
alphabet: "MapTiles"
position: (7,-26)
type: Recipe
match: None
inputs: "Enlarge"
grammar: true
executionType: Cellular
recipe: true
showMembers: true

module:
name: "DoGround"
alphabet: "MapTiles"
position: (145,-30)
type: Recipe
match: None
inputs: "CombineTerrain"
grammar: true
executionType: LSystem
recipe: true
showMembers: true

module:
name: "Recombine"
alphabet: "MapTiles"
position: (237,56)
type: Recipe
match: StackTiles
inputs: "DoGround"
maxIterations: 5
grammar: true
recipe: true
showMembers: true

module:
name: "SetSpawnLocations"
alphabet: "MapTiles"
position: (144,124)
type: Recipe
match: None
inputs: "CombineTerrain"
maxIterations: 5
grammar: true
executionType: LSystem
recipe: true
showMembers: true

register: width 9
register: height 5
register: requests ["moonlight", "flowstone", "bigLeaves"]
register: setRequests false
register: terrainA "high"
register: terrainB "bushes"
register: terrainC "bushes"
register: terrainD "shallowWater"
register: terrainE "bushes"
register: terrainF "bushes"
register: elevation 12
register: entrance "west"
register: barrierX null
option: Width 9
option: Height 5
option: Tile "undefined"
option: Register "requests"
option: Find "blocked"
option: Replace "undefined"
option: SplitX 5
option: SplitY 5