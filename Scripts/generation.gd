extends Node



@onready var room_scene : PackedScene = load("res://Eroz-s-Adventure/Scenes/Room.tscn")

# Map and Room Generation Settings
var map_width : int = 7
var map_height : int = 7
var rooms_to_generate : int = 12
var room_count : int = 0
var first_room_pos : Vector2

# Map and Room Data
var map : Array = []
var room_nodes : Array = []

# Probability and Limits for Spawns
@export var enemy_spawn_chance : float
@export var coin_spawn_chance : float
@export var heart_spawn_chance : float
@export var max_enemies_per_room : int
@export var max_coins_per_room : int
@export var max_hearts_per_room : int

func _ready() -> void:
	# Initialize the map and generate rooms
	initialize_map()
	generate_map()
	instantiate_rooms()
	
	# Set the player’s starting position
	$"../Player".global_position = first_room_pos * 50

func initialize_map() -> void:
	# Initialize a blank map grid
	for i in range(map_width):
		map.append([])
		for j in range(map_height):
			map[i].append(false)

func generate_map() -> void:
	# Start map generation from the center
	check_room(map_width / 2, map_height / 2, rooms_to_generate, Vector2.ZERO, true)
	print_map()

func check_room(x: int, y: int, remaining: int, direction: Vector2, is_first_room: bool = false) -> void:
	if room_count >= rooms_to_generate or remaining <= 0:
		return
	if x < 0 or x >= map_width or y < 0 or y >= map_height:
		return
	if map[x][y]:
		return

	# Mark the room on the map and update counters
	map[x][y] = true
	room_count += 1
	if is_first_room:
		first_room_pos = Vector2(x, y)

	# Generate neighboring rooms
	for dir in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		if is_first_room or randf() > 0.5:
			var new_x = x + int(dir.x)
			var new_y = y + int(dir.y)
			check_room(new_x, new_y, remaining - 1, dir)

func instantiate_rooms() -> void:
	# Create room nodes based on the generated map data
	for x in range(map_width):
		for y in range(map_height):
			if not map[x][y]:
				continue
			create_room(Vector2(x, y))
			
	# Add key and exit logic once all rooms are created
	calculate_key_and_exit()

func create_room(room_pos: Vector2) -> void:
	# Instantiate a room and set up its position and connections
	var room = room_scene.instantiate()
	room.position = room_pos * 200
	configure_room_connections(room, room_pos)
	if first_room_pos != room_pos:
		room.Generation = self
	$"..".call_deferred("add_child", room)
	room_nodes.append(room)

func configure_room_connections(room: Node2D, room_pos: Vector2) -> void:
	# Set up room doors based on map connections
	var x = int(room_pos.x)
	var y = int(room_pos.y)

	if y > 0 and map[x][y - 1]: room.north()
	if y < map_height - 1 and map[x][y + 1]: room.south()
	if x > 0 and map[x - 1][y]: room.west()
	if x < map_width - 1 and map[x + 1][y]: room.east()

func calculate_key_and_exit() -> void:
	# Set the most distant rooms to contain the key and exit
	var max_distance : float = 0
	var room_a : Node2D = null
	var room_b : Node2D = null
	
	for a in room_nodes:
		for b in room_nodes:
			var distance = a.position.distance_to(b.position)
			if distance > max_distance:
				max_distance = distance
				room_a = a
				room_b = b
	
	 # Assign key and exit to the two farthest rooms
	if room_a and room_b:
		room_a.spawn_key()
		room_b.spawn_exit_door()

func print_map() -> void:
	# LET THERE BE LIGHT
	var map_str = ""
	for y in range(map_height):
		for x in range(map_width):
			map_str += "O" if map[x][y] else "X"
		map_str += "\n"
	print(map_str)
