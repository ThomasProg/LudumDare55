extends Node

@export var abilityOwner:Node2D
@export var toSpawn:PackedScene
@export var cost:float = 10
@export var cooldown:float = 0.5

func start():
	if (abilityOwner.currentPoints < cost):
		queue_free()
		return 
	abilityOwner.currentPoints -= cost
	
	
	var spawned = toSpawn.instantiate() as Node2D
	abilityOwner.get_parent().add_child(spawned)
	spawned.global_position = abilityOwner.global_position
	spawned.team = abilityOwner.team
	spawned.find_child("Controller").mainTarget = GameManager.findEnemyMainCharacter(spawned.team)
	GameManager.entities.push_back(spawned)
	
	
	abilityOwner.modulate = Color.GREEN
	
	await abilityOwner.get_tree().create_timer(0.1).timeout
	if (is_instance_valid(abilityOwner)):
		abilityOwner.modulate = Color.WHITE
		
	queue_free()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
