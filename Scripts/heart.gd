extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if Global.health < Global.max_health:
			Global.health += 1
			queue_free()
