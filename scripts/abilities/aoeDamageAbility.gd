extends Area2D

@export var abilityOwner:MainCharacter

@export var dmg:float = 10
@export var cost:float = 1
@export var cooldown:float = 1.0

@onready var particles:GPUParticles2D = $GPUParticles2D

func start():
	global_position = abilityOwner.global_position
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	if ((!is_instance_valid(abilityOwner)) or abilityOwner.currentPoints < cost):
		queue_free()
		return 
	abilityOwner.currentPoints -= cost
	
	particles.emitting = true
	
	abilityOwner.isStopped = true
	for mainCharacter in get_overlapping_bodies():
		mainCharacter.dealDamages(dmg, abilityOwner)
			
	
	#abilityOwner.modulate = Color.BLUE
	abilityOwner.animPlayer.animation_finished.connect(func(anim_name: StringName):
		if (is_instance_valid(abilityOwner)):
			abilityOwner.isStopped = false
		queue_free()
		)
	abilityOwner.animPlayer.play("attack")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
