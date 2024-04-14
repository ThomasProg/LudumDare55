extends CanvasLayer

@export var playerLifeProgressBar: ProgressBar
@export var enemyLifeProgressBar: ProgressBar
@export var player: MainCharacter
@export var enemy: MainCharacter

@export var abilitiesContainer:Node

@export var abilityButtonPrefabs:Array[PackedScene] = []

@export var pointsLabel:RichTextLabel
@export var timescaleSlider:Slider

@export var infoLabel:RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	for abilityButtonPrefab in abilityButtonPrefabs:
		var button = abilityButtonPrefab.instantiate()
		button.abilityOwner = player
		abilitiesContainer.add_child(button)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(player):
		playerLifeProgressBar.max_value = player.maxLife
		playerLifeProgressBar.value = player.currentLife
		
		pointsLabel.text = "Points: [color=yellow]%d[/color] " % player.currentPoints
	else:
		playerLifeProgressBar.value = 0
		infoLabel.text = "Too bad, you lost! Retry! - Prog'z"

	GameManager.timeScale = timescaleSlider.value / 100.0

	if is_instance_valid(enemy):
		enemyLifeProgressBar.max_value = enemy.maxLife
		enemyLifeProgressBar.value = enemy.currentLife
	else:
		enemyLifeProgressBar.value = 0
		infoLabel.text = "Well played, you won! - Prog'z"
