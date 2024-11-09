extends Node2D



var inside_width : int = 8
var inside_height : int = 7

@onready var Generation : Node

@export var enemy_node : PackedScene
@export var coin_node : PackedScene
@export var heart_node : PackedScene
@export var key_node : PackedScene
@export var exit_door_node : PackedScene

var used_positions : Array = []

func _ready() -> void:
	if Generation:
		generate_interior()


func north() -> void:
	$"North Door".visible = true
	$"Norh Walll".queue_free()

func south() -> void:
	$"South Door".visible = true
	$"South Wall".queue_free()
	
func east() -> void: 
	$"East Door".visible = true
	$"East Wall".queue_free()
	
func west() -> void: 
	$"West Door".visible = true
	$"West Wall".queue_free()

func generate_interior() -> void:
	if randf_range(0,1) < Generation.enemy_spawn_chance:
		spawn_nodes(enemy_node, 1, Generation.max_enemies_per_room)
	if randf_range(0,1) < Generation.coin_spawn_chance:
		spawn_nodes(coin_node, 1, Generation.max_coins_per_room)
	if randf_range(0,1) < Generation.heart_spawn_chance:
		spawn_nodes(heart_node, 1, Generation.max_hearts_per_room)
		
		
func spawn_nodes(node_scene : PackedScene, min_ins : int = 0,max_ins : int = 0) -> void:
	var num : int = 1 
	if min_ins != 0 or max_ins != 0:
		num = randi_range(min_ins, max_ins)
	for i in range(num):
		var node_obj = node_scene.instantiate()
		var pos : Vector2 = Vector2(48 * randi_range(2, inside_width -1) -24, 48 * randi_range(2, inside_height -1) -24)
		while pos in used_positions:
			pos = Vector2(48 * randi_range(2, inside_width -1) -24, 48 * randi_range(2, inside_height -1) -24)
		node_obj.position = pos 
		used_positions.append(pos)
		add_child(node_obj)
		if node_scene == enemy_node:
			get_tree().get_first_node_in_group("Enemy Manager").check_enemies()
			


func spawn_key() -> void:
	if key_node:
		var key_instance = key_node.instantiate()
		add_child(key_instance)
		key_instance.position = Vector2(50, 50)
	else:
		print("Warning: key_scene is not assigned in room.gd.")

func spawn_exit_door() -> void:
	if  exit_door_node :
		var exit_door_instance = exit_door_node.instantiate()
		add_child(exit_door_instance)
		exit_door_instance.position = Vector2(150, 150)
	else:
		print("Warning: exit_door_scene is not assigned in room.gd.")
