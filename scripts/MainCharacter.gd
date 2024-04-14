extends CharacterBody2D
class_name MainCharacter

@export var speed = 50.0
@export var currentLife = 100.0
@export var maxLife = 100.0

@export var team:int = 0:
	get:
		return team
	set(value):
		team = value
		resetColor()

@export var currentPoints:float = 0
@export var pointsPerSecond:float = 2

@export var isStopped:bool = false

@onready var navAgent:NavigationAgent2D = $NavigationAgent2D

var abilityToCooldownMap = {}



func resetColor():
	match team:
		0:
			modulate = lerp(Color.WHITE, Color.DARK_BLUE, 0.3)
		1:
			modulate = lerp(Color.WHITE, Color.DARK_RED, 0.3)

func dealDamages(damages, attacker:Node):
	
	if ("team" in attacker):
		if (attacker.team == team):
			return 
	
	currentLife -= damages
	
	if (currentLife <= 0):
		queue_free()
		GameManager.removeMainCharacter(self)
	else:
		modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		resetColor()

func runAbility(abilityPrefab:PackedScene, setupCallable:Callable = func(a):):
	if abilityPrefab in abilityToCooldownMap:
		return
	
	
	var ability = abilityPrefab.instantiate()
	abilityToCooldownMap[abilityPrefab] = ability.cooldown
	ability.abilityOwner = self
	setupCallable.call(ability)
	add_child(ability)
	ability.start()

func _physics_process(delta):
	if isStopped or navAgent.is_navigation_finished():
		return

	var next_path_position: Vector2 = navAgent.get_next_path_position()
	velocity = global_position.direction_to(navAgent.get_next_path_position()) * speed * GameManager.timeScale


	move_and_slide()

func _process(delta):
	currentPoints += pointsPerSecond * (delta * GameManager.timeScale)
	
	for ability in abilityToCooldownMap.keys():
		abilityToCooldownMap[ability] -= (delta * GameManager.timeScale)
		if (abilityToCooldownMap[ability] <= 0.0):
			abilityToCooldownMap.erase(ability)
