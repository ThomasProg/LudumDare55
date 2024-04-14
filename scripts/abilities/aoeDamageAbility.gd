extends Area2D

@export var abilityOwner:MainCharacter

@export var dmg:float = 10
@export var cost:float = 1
@export var cooldown:float = 1.0

func start():
	await abilityOwner.get_tree().physics_frame
	await abilityOwner.get_tree().physics_frame
	
	if (abilityOwner.currentPoints < cost):
		queue_free()
		return 
	abilityOwner.currentPoints -= cost
	
	abilityOwner.isStopped = true
	for mainCharacter in get_overlapping_bodies():
		mainCharacter.dealDamages(dmg, abilityOwner)
			
	
	abilityOwner.modulate = Color.BLUE
	
	await abilityOwner.get_tree().create_timer(0.1).timeout
	
	if (is_instance_valid(abilityOwner)):
		abilityOwner.isStopped = false
		abilityOwner.resetColor()
	
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
