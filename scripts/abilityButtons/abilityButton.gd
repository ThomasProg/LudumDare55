extends Button
class_name AbilityButton

@export var abilityOwner:Node
@export var abilityPrefab: PackedScene
#@export_file("*.gd") var abilityPath: String

# Called when the node enters the scene tree for the first time.
func _ready():
	button_down.connect(func():
		if is_instance_valid(abilityOwner):
			abilityOwner.runAbility(abilityPrefab)
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

