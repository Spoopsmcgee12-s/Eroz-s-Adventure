extends Node


var enemies : Array = []
var player : CharacterBody2D

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	check_enemies()  
	player.connect("player_moved", Callable(self, "on_player_moved"))

func check_enemies() -> void:
	enemies = get_tree().get_nodes_in_group("Enemy")

func on_player_moved() -> void:
	for enemy in enemies:
		if enemy:
			enemy.move()
