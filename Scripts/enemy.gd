extends CharacterBody2D

@onready var player = get_tree().get_nodes_in_group("Player")[0]
var health : int = 3
var damage : int = 1
var attack_chance : float = 0.5

func _ready() -> void:
	add_to_group("Enemy")

func move() -> void:
	if randf() < attack_chance:
		return 

	var direction : Vector2 = get_random_direction()
	var query = PhysicsRayQueryParameters2D.new()
	query.from = global_position
	query.to = global_position + (direction * 5)

	var result = get_world_2d().direct_space_state.intersect_ray(query)
	if not result or not result.collider.is_in_group("Wall"):
		global_position += direction * 5 

func get_random_direction() -> Vector2:
	match randi_range(0, 3):
		0: return Vector2.UP
		1: return Vector2.DOWN
		2: return Vector2.RIGHT
		3: return Vector2.LEFT
	return Vector2.ZERO

func take_damage(damage_taken : int) -> void:
	Global.health -= damage_taken
	if health <= 0:
		queue_free()
		$AnimationPlayer.play("Hit") 
	if randf() > attack_chance:
		player.take_damage(damage)
	
