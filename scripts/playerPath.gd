extends Node2D

@export var player:MainCharacter

# Called when the node enters the scene tree for the first time.
func _ready():
	player.navAgent.path_changed.connect(func():
		queue_redraw()
		)


func _draw():
	var positions = player.navAgent.get_current_navigation_path()
	for i in range(positions.size() - 1):
		draw_line(to_local(positions[i]), to_local(positions[i+1]), Color.CADET_BLUE, 5)
	
