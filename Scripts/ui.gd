extends CanvasLayer

@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var Generation : Node = $"../Generation"

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
