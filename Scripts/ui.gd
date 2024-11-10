extends CanvasLayer


@onready var player = get_tree().get_first_node_in_group("Player")
@onready var generation = $"../Generation"
@onready var grid_scene = load("res://Eroz-s-Adventure/Scenes/mini_map_grid.tscn")

func _ready() -> void:
	if player:
		player.connect("health_changed", self, "_on_player_health_changed")
		player.connect("coin_count_changed", self, "_on_player_coin_count_changed")
		player.connect("key_acquired", self, "_on_player_key_acquired")
	generate_mini_map()
	update_ui()

func _process(delta: float) -> void:
	update_level_display()
	update_mini_map()

func _on_player_health_changed(health: int) -> void:
	update_health_bar(health)

func _on_player_coin_count_changed(coin_count: int) -> void:
	update_coin_count(coin_count)

func _on_player_key_acquired(has_key: bool) -> void:
	update_key_indicator(has_key)

func update_coin_count(coin_count: int) -> void:
	$"Stat Block/Coin Label".text = str(coin_count)

func update_key_indicator(has_key: bool) -> void:
	$"Stat Block/Key Indicator".modulate = Color(1, 1, 1) if has_key else Color(0.16, 0.16, 0.73, 0.73)

func update_level_display() -> void:
	$"Mini Map/Level Label".text = "Level: %s" % Global.level

func update_health_bar(health: int) -> void:
	var health_frames = [2, 2, 1, 0]
	for i in range(4):
		$"Health Bar/Player Health%d" % (i + 1).frame = health_frames[min(health - i * 2, 0)]

func update_mini_map() -> void:
	var player_pos: Vector2i = (player.global_position / 50)
	for panel in $"Mini Map/GridContainer".get_children():
		panel.modulate = Color(1, 1, 1) if panel.is_room else Color(1, 1, 0)
		if panel.pos == player_pos:
			panel.modulate = Color(0, 0.48, 0.15)

func generate_mini_map() -> void:
	$"Mini Map/GridContainer".columns = generation.map_width
	for y in range(generation.map_height):
		for x in range(generation.map_width):
			var panel = grid_scene.instantiate()
			panel.is_room = generation.map[x][y]
			panel.modulate = Color(1, 1, 0) if not panel.is_room else Color(1, 1, 1)
			panel.pos = Vector2i(x, y)
			$"Mini Map/GridContainer".add_child(panel)
[10:15 PM]
func _ready() -> void:
	if player:
		player.connect("health_changed", Callable(self, "_on_player_health_changed"))
		player.connect("coin_count_changed", Callable(self, "_on_player_coin_count_changed"))
		player.connect("key_acquired", Callable(self, "_on_player_key_acquired"))
