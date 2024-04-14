extends Node2D
class_name RangedAttack

@export var abilityOwner:MainCharacter
@export var dmg:float = 10
@export var cost:float = 1
@export var cooldown:float = 0.5
@export var speedMultiplicator:float = 0.5

@export var laserTo:Vector2
@export var beamColor:Color

@onready var animPlayer:AnimationPlayer = $AnimationPlayer

var hitEntity

func _draw():
	draw_line(Vector2.ZERO, to_local(laserTo), beamColor, 5.0)


func _process(delta):
	queue_redraw()

func start():
	global_position = abilityOwner.global_position
	if (abilityOwner.currentPoints < cost):
		queue_free()
		return 
		
	animPlayer.play("startLaser")
		
	abilityOwner.currentPoints -= cost
	
	abilityOwner.isStopped = true
	
	
	var space_state = abilityOwner.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(abilityOwner.global_position, laserTo)
	var result = space_state.intersect_ray(query)
	
	if (result):
		hitEntity = result.collider
		if (hitEntity is MainCharacter):
			hitEntity.dealDamages(dmg, abilityOwner)
			hitEntity.speed *= speedMultiplicator
	
			abilityOwner.animPlayer.animation_finished.connect(func(anim_name: StringName):
				if (is_instance_valid(abilityOwner)):
					abilityOwner.isStopped = false
					
				if (is_instance_valid(hitEntity) and hitEntity is MainCharacter):
					hitEntity.speed /= speedMultiplicator
					
				queue_free()
				)
			abilityOwner.animPlayer.play("attack")
			return
			
	queue_free()
