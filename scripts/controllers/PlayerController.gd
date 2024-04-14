extends Node

@export var controlledPawn: MainCharacter

@export var target: Node2D

func _physics_process(delta):
	#var hDir = Input.get_axis("left", "right")
	#var vDir = Input.get_axis("up", "down")
	#if hDir or vDir:
		#var dir = Vector2(hDir, vDir).normalized()
		#controlledPawn.velocity = dir * controlledPawn.speed
	#else:
		#controlledPawn.velocity = Vector2.ZERO
		

	if Input.is_action_pressed("moveClick") and is_instance_valid(controlledPawn):
		controlledPawn.navAgent.set_target_position(controlledPawn.get_global_mouse_position())

