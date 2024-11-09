extends Node


#player spawns in the base room but no other doors spawn to let player out of base room, fix this later.
#nothing spawns inside rooms which is a complete bug and somehow needs to be fixed.
#player base room still doesnt open any walls when a door is also base is no connected to it, also doesnt move with map generation so base and map wont conect on 99% of map generation outcomes.
#have tried to fix all of these issue and nothing has worked this far~Lexi <3
@onready var room_scene : PackedScene = load("res://Eroz-s-Adventure/Scenes/Room.tscn")
var map_width : int = 7
var map_height : int = 7
var rooms_to_generate : int = 12
var room_count : int = 0
var first_room_pos : Vector2

var map : Array = []
var room_nodes : Array = []

@export var enemy_spawn_chance : float
@export var coin_spawn_chance : float
@export var heart_spawn_chance : float

@export var max_enemies_per_room : float
@export var max_coins_per_room : float
@export var max_hearts_per_room : float



func _ready() -> void:
	for i in range(map_width):
		map.append([])
		for j in range(map_height):
			map[i].append(false)
			
	generate()
	seed(Global.seed)
	instantiate_rooms()
	$"../Player".global_position = (first_room_pos * 50)

func check_room(x: int, y: int, remaining: int, general_direction: Vector2, first_room: bool = false) -> void:
	if room_count >= rooms_to_generate:
		return

	if x < 0 or x >= map_width or y < 0 or y >= map_height:
		return
	if not first_room and remaining <= 0:
		return

	if map[x][y] == true:
		return

	if first_room:
		first_room_pos = Vector2(x, y)
	room_count += 1
	map[x][y] = true

	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	

	for direction in directions:
		var new_x = x + int(direction.x)
		var new_y = y + int(direction.y)
		var should_generate = randf() > 0.5 
		if should_generate or first_room:
			check_room(new_x, new_y, remaining - 1, direction, false)

func generate() -> void:
	check_room(map_width /2 , map_height /2 , rooms_to_generate, Vector2.ZERO, true)
	print_map()

func print_map():
	var map_string = ""
	for y in range(map_height):
		for x in range(map_width):
			map_string += "O" if map[x][y] else "X"
		map_string += "\n"
	print(map_string)

func instantiate_rooms() -> void:
	for x in range(map_width):
		for y in range(map_height):
			if map[x][y] == false:
				continue
			var room = room_scene.instantiate()
			room.position = Vector2(x, y) * 200
			if y > 0 and map[x][y - 1] == true:
				room.north()
			if y < map_height - 1 and map[x][y + 1] == true:
				room.south()
			if x > 0 and map[x - 1][y] == true:
				room.west()
			if x < map_width - 1 and map[x + 1][y] == true:
				room.east()

			if first_room_pos != Vector2(x, y):
				room.Generation = self
				
			$"..".call_deferred("add_child", room)
			room_nodes.append(room)
	get_tree().create_timer(1)
	calculate_key_and_exit()
	
func calculate_key_and_exit() -> void:
	var max_dis : float = 0
	var room_a : Node2D = null
	var room_b : Node2D = null
	
	for a : Node2D in room_nodes:
		for b : Node2D in room_nodes:
			var dis : float = a.position.distance_to(b.position)
			
