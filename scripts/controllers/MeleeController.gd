extends Node

@export var controlledPawn: MainCharacter
@export var mainTarget: Node2D

@export var attackRange: Area2D
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
	
	var bodiesInRange = attackRange.get_overlapping_bodies()
	bodiesInRange = bodiesInRange.filter(func(body:Node2D):
		return body is MainCharacter and body.team != controlledPawn.team and body != controlledPawn
		)
	
	if (!bodiesInRange.is_empty()):	
		controlledPawn.runAbility(abilityPrefab)
	
	updateTarget()
