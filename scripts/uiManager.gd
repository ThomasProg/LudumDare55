extends CanvasLayer

@export var playerLifeProgressBar: ProgressBar
@export var player: MainCharacter

@export var abilitiesContainer:Node

@export var abilityButtonPrefabs:Array[PackedScene] = []

@export var pointsLabel:RichTextLabel
@export var timescaleSlider:Slider

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
		
		pointsLabel.text = "[right]Points : %d [/right]" % player.currentPoints

		GameManager.timeScale = timescaleSlider.value / 100.0
