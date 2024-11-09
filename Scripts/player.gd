extends CharacterBody2D

var damage : int = 1
var health : int = 8
var attack_chance : float = 0.5
var has_key : bool = false
signal player_moved

func player_input() -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move down"):
		velocity = Vector2.DOWN
	elif Input.is_action_pressed("move left"):
		velocity = Vector2.LEFT
	elif Input.is_action_pressed("move right"):
		velocity = Vector2.RIGHT
	elif Input.is_action_pressed("move up"):
		velocity = Vector2.UP

	if velocity != Vector2.ZERO:
		move(velocity)
		
	if Input.is_action_just_pressed("attack up"):
		try_attack(Vector2.UP)
	if Input.is_action_just_pressed("attack down"):
		try_attack(Vector2.DOWN)
	if Input.is_action_just_pressed("attack left"):
		try_attack(Vector2.LEFT)
	if Input.is_action_just_pressed("attack right"):
		try_attack(Vector2.RIGHT)
		

func try_attack(direction : Vector2) -> void:
	var query = PhysicsRayQueryParameters2D.new()
	query.from = global_position
	query.to = global_position + (direction * 5)  

	var result = get_world_2d().direct_space_state.intersect_ray(query)
	if not result or not result.collider.is_in_group("Wall"):
		global_position += direction * 5  
		#this doesnt work for some reson this should tell the player to take damage however for some reason it quits working once i press the action keys for the player attack
	if not result or result.collider.is_in_group("Enemy"):
		result.collider.take_damage(1)
		

func move(direction: Vector2) -> void:
	var query = PhysicsRayQueryParameters2D.new()
	query.from = global_position
	query.to = global_position + (direction * 5)  

	var result = get_world_2d().direct_space_state.intersect_ray(query)
	if not result or not result.collider.is_in_group("Wall"):
		global_position += direction * 5
		emit_signal("player_moved")



func _physics_process(_delta: float) -> void:
	player_input()





func take_damage(damage_taken: int) -> void:
	Global.health -= damage_taken
	var player = get_tree().get_nodes_in_group("Player")[0]
	$AnimationPlayer.play("Player Hit")
	if randf() > attack_chance:
		player.take_damage(damage)
		get_tree().reload_current_scene()
	
