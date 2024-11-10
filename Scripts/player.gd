extends CharacterBody2D

@export var damage : int = 1
@export var max_health : int = 8
var health : int = max_health
@export var attack_chance : float = 0.5
var has_key : bool = false
signal player_moved
signal health_changed
signal coin_count_updated
signal key_acquired


 
func _ready() -> void:
	# Ensure proper health setup and connect signals here
	update_health_ui()

func _physics_process(_delta: float) -> void:
	handle_input()

# Main function to handle player input for movement and attacks
func handle_input() -> void:
	var velocity = Vector2.ZERO

	# Movement Controls
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	elif Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	elif Input.is_action_pressed("move_left"):
		velocity.x -= 1

	# Move player if there's input
	if velocity != Vector2.ZERO:
		move(velocity.normalized())
		emit_signal("player_moved")

	# Attack Controls
	if Input.is_action_just_pressed("attack_up"):
		try_attack(Vector2.UP)
	elif Input.is_action_just_pressed("attack_down"):
		try_attack(Vector2.DOWN)
	elif Input.is_action_just_pressed("attack_left"):
		try_attack(Vector2.LEFT)
	elif Input.is_action_just_pressed("attack_right"):
		try_attack(Vector2.RIGHT)

# Perform an attack in the given direction
func try_attack(direction : Vector2) -> void:
	var query = PhysicsRayQueryParameters2D.new()
	query.from = global_position
	query.to = global_position + (direction * 5)  # Adjust this as needed for attack range

	var result = get_world_2d().direct_space_state.intersect_ray(query)
	if result:
		var collider = result.collider
		if collider and collider.is_in_group("Enemy"):
			collider.take_damage(damage)

# Moves the player in the specified direction, if there are no obstacles
func move(direction: Vector2) -> void:
	var query = PhysicsRayQueryParameters2D.new()
	query.from = global_position
	query.to = global_position + (direction * 10)  # Adjust for movement range

	var result = get_world_2d().direct_space_state.intersect_ray(query)
	if not result or not result.collider.is_in_group("Wall"):
		global_position += direction * 10  # Adjust for step distance

# Function to take damage; updates health and checks for player death
func take_damage(damage_taken: int) -> void:
	health -= damage_taken
	update_health_ui()
	if health <= 0:
		die()

# Update the UI with the player's current health status
func update_health_ui() -> void:
	Global.health = health

# Called when the player's health reaches 0
func die() -> void:
	get_tree().reload_current_scene()
