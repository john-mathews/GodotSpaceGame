extends Area2D

@export var speed := 600.0
var ship_velocity := Vector2.ZERO
var attack_power: int = 2
var movement_vector := Vector2(0,-1)


func _physics_process(delta: float):
	global_position += movement_vector.rotated(rotation) * (speed + ship_velocity.x) * delta
	
func _on_off_screen_kill_timer_kill_parent() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Asteroid2:
		var asteroid = body
		asteroid.take_damage(attack_power)
		queue_free()
