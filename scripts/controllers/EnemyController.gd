extends Node

@export var controlledPawn: MainCharacter

@export var target: Node2D
@export var center: Node2D

@export var spawnMeleePrefab:PackedScene

func _ready():
	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	updateTarget()

func updateTarget():
	if is_instance_valid(controlledPawn) and is_instance_valid(target):
		var targetPos = center.global_position + (center.global_position - target.global_position)
		controlledPawn.navAgent.set_target_position(targetPos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(controlledPawn):
		controlledPawn.runAbility(spawnMeleePrefab)

func _physics_process(delta):
	updateTarget()
