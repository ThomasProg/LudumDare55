extends Node2D
class_name RangedAttack

@export var abilityOwner:MainCharacter
@export var targets:Array[MainCharacter]

@export var dmg:float = 10
@export var cost:float = 1
@export var cooldown:float = 0.5

@export var laserTo:Vector2

func start():
	if (abilityOwner.currentPoints < cost):
		queue_free()
		return 
	abilityOwner.currentPoints -= cost
	
	abilityOwner.isStopped = true
	
	
	var space_state = abilityOwner.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(abilityOwner.global_position, laserTo)
	var result = space_state.intersect_ray(query)
	
	if (result and result.collider is MainCharacter):
		result.collider.dealDamages(dmg, abilityOwner)
	
	#for mainCharacter in get_overlapping_bodies():
		#mainCharacter.dealDamages(dmg, abilityOwner)
	
	
	abilityOwner.modulate = Color.BLUE
	
	await abilityOwner.get_tree().create_timer(0.5).timeout
	
	if (is_instance_valid(abilityOwner)):
		abilityOwner.isStopped = false
		abilityOwner.resetColor()
	
	queue_free()
