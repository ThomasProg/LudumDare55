extends Node

@export var controlledPawn: MainCharacter
@export var mainTarget: Node2D

@export var abilityPrefab: PackedScene

func _ready():
	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	updateTarget()

func updateTarget():
	if is_instance_valid(controlledPawn) and is_instance_valid(mainTarget):
		controlledPawn.navAgent.set_target_position(mainTarget.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
	
	var hitEntity:MainCharacter = null
	var laserTo:Vector2
	for dir in directions:
		var space_state = controlledPawn.get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(controlledPawn.global_position, controlledPawn.global_position + (32*10) * dir)
		var result = space_state.intersect_ray(query)
		
		if (result and result.collider is MainCharacter):
			if (result.collider.team != controlledPawn.team):
				hitEntity = result.collider
				laserTo = result.position
				break
		
	if (hitEntity != null):
		controlledPawn.runAbility(abilityPrefab, func(ability:RangedAttack):
			ability.laserTo = laserTo
			)
	
	updateTarget()
