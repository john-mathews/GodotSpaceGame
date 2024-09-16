extends Area2D

@export var speed := 600.0
var attack_power := 2
var movement_vector := Vector2(0,-1)


func _physics_process(delta: float):
	global_position += movement_vector.rotated(rotation) * speed * delta
	
	
func _on_off_screen_kill_timer_kill_parent() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Asteroid:
		var asteroid = body
		asteroid.take_damage(attack_power)
		queue_free()
