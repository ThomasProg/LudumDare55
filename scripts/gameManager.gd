extends Node

var player:MainCharacter
var mainCharacters:Array[MainCharacter] = []

var entities:Array[Node2D] = []

var timeScale:float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().root.find_child("Player")

	var mainChars = get_tree().root.find_children("*", "MainCharacter", true, false)
	for main in mainChars:
		mainCharacters.push_back(main)
		entities.push_back(main)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func removeMainCharacter(mainCharacter):
	mainCharacters.erase(mainCharacter)
	entities.erase(mainCharacter)
	if (player == mainCharacter):
		player = null

func findMainCharacterInTeam(team):
	var charactersFromTeam = mainCharacters.filter(func(a:MainCharacter): return a.team == team)
	if (charactersFromTeam.is_empty()):
		return null
	return charactersFromTeam[0]

func findEnemyMainCharacter(team):
	match team:
		0:
			return findMainCharacterInTeam(1)
		1:
			return findMainCharacterInTeam(0)


#func refresh():
	#mainCharacters = mainCharacters.filter(func(a): return is_instance_valid(a))
	#servants = servants.filter(func(a): return is_instance_valid(a))
#
