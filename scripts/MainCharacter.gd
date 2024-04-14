extends CharacterBody2D
class_name MainCharacter

@export var speed = 50.0
@export var currentLife = 100.0
@export var maxLife = 100.0

@onready var animPlayer:AnimationPlayer = $AnimationPlayer
@onready var damagedAnimPlayer:AnimationPlayer = $DamagedAnimationPlayer
@onready var particles:GPUParticles2D = $GPUParticles2D

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
	modulate = Color.WHITE
	if (particles == null):
		return
	
	match team:
		0:
			particles.modulate = lerp(Color.WHITE, Color.DARK_BLUE, 1.0)
		1:
			particles.modulate = lerp(Color.WHITE, Color.DARK_RED, 1.0)

func _ready():
	resetColor()

func dealDamages(damages, attacker:Node):
	
	if ("team" in attacker):
		if (attacker.team == team):
			return 
	
	currentLife -= damages
	
	if (currentLife <= 0):
		queue_free()
		GameManager.removeMainCharacter(self)
	else:
		damagedAnimPlayer.play("onAttacked")
		#modulate = lerp(Color.WHITE, Color.DARK_RED, 0.3)
		#await get_tree().create_timer(0.1).timeout
		#resetColor()

func runAbility(abilityPrefab:PackedScene, setupCallable:Callable = func(a):):
	if abilityPrefab in abilityToCooldownMap:
		return
	
	
	var ability = abilityPrefab.instantiate()
	abilityToCooldownMap[abilityPrefab] = ability.cooldown
	ability.abilityOwner = self
	setupCallable.call(ability)
	get_parent().add_child(ability)
	ability.start()

func _physics_process(delta):
	if isStopped or navAgent.is_navigation_finished():
		return

	var next_path_position: Vector2 = navAgent.get_next_path_position()
	velocity = global_position.direction_to(navAgent.get_next_path_position()) * speed * GameManager.timeScale

	if (navAgent.avoidance_enabled):
		navAgent.set_velocity(velocity)
	else:
		move_and_slide()

func _process(delta):
	currentPoints += pointsPerSecond * (delta * GameManager.timeScale)
	
	for ability in abilityToCooldownMap.keys():
		abilityToCooldownMap[ability] -= (delta * GameManager.timeScale)
		if (abilityToCooldownMap[ability] <= 0.0):
			abilityToCooldownMap.erase(ability)


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if (isStopped):
		return
	velocity = safe_velocity
	move_and_slide()
