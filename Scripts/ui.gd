extends CanvasLayer

@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var Generation : Node = $"../Generation"
@onready var grid : PackedScene = load("res://Eroz-s-Adventure/Scenes/mini_map_grid.tscn")

func _ready() -> void:
	generate_mini_map()

func _process(delta) -> void:
	$"Stat Block/Coin Label".text = str(Global.coin)
	
	#Handle Key
	if player.has_key:
		$"Stat Block/Key Indicator".modulate = "ffffff"
	else:
		$"Stat Block/Key Indicator".modulate = "2a2a2abe"

	match Global.health:
		8:
			$"Health Bar/Player Health".frame = 2
			$"Health Bar/Player Health2".frame = 2
			$"Health Bar/Player Health3".frame = 2
			$"Health Bar/Player Health4".frame = 2
		7:
			$"Health Bar/Player Health".frame = 2
			$"Health Bar/Player Health2".frame = 2
			$"Health Bar/Player Health3".frame = 2
			$"Health Bar/Player Health4".frame = 1
		6:
			$"Health Bar/Player Health".frame = 2
			$"Health Bar/Player Health2".frame = 2
			$"Health Bar/Player Health3".frame = 2
			$"Health Bar/Player Health4".frame = 0
		5:
			$"Health Bar/Player Health".frame = 2
			$"Health Bar/Player Health2".frame = 2
			$"Health Bar/Player Health3".frame = 1
			$"Health Bar/Player Health4".frame = 0
		4:
			$"Health Bar/Player Health".frame = 2
			$"Health Bar/Player Health2".frame = 2
			$"Health Bar/Player Health3".frame = 0
			$"Health Bar/Player Health4".frame = 0
		3:
			$"Health Bar/Player Health".frame = 2
			$"Health Bar/Player Health2".frame = 1
			$"Health Bar/Player Health3".frame = 0
			$"Health Bar/Player Health4".frame = 0
		2:
			$"Health Bar/Player Health".frame = 2
			$"Health Bar/Player Health2".frame = 0
			$"Health Bar/Player Health3".frame = 0
			$"Health Bar/Player Health4".frame = 0
		1: 
			$"Health Bar/Player Health".frame = 1
			$"Health Bar/Player Health2".frame = 0
			$"Health Bar/Player Health3".frame = 0
			$"Health Bar/Player Health4".frame = 0
		0:
			$"Health Bar/Player Health".frame = 0
			$"Health Bar/Player Health2".frame = 0
			$"Health Bar/Player Health3".frame = 0
			$"Health Bar/Player Health4".frame = 0


func generate_mini_map() -> void:
	$"Mini Map/GridContainer".columns = Generation.map_width
	for i in range(Generation.map_height):
		for j in range(Generation.map_width):
			var panel = grid.instantiate()
			if Generation.map[j][i] == false:
				panel.modulate = "ffff00"
			else:
			#Error:Invalid assignment of property or key 'is_in_room' 
			#with value of type 'bool' on a base object of type 
			#'Panel (mini_map_grid.gd)'.
				panel.is_in_room = true 
			panel.pos = Vector2i(j, i)
			$"Mini Map/GridContainer".add_child(panel)
