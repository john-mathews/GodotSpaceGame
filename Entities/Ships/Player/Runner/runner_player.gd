class_name RunnerPlayer extends Player

const ACCELERATION = 10
const STRAFE = 250
@onready var camera := $Camera2D

func _physics_process(delta: float) -> void:
	velocity.x += (delta * ACCELERATION)
	
	var input_vector := Vector2(0, Input.get_axis("move_forward","move_backward"))
	if position.y > (camera.limit_top + 25) && input_vector.y < 0:
		velocity.y = input_vector.y * STRAFE 
	elif position.y < (camera.limit_bottom - 25) && input_vector.y > 0:
		velocity.y = input_vector.y * STRAFE 
	else:
		velocity.y = 0

	
	move_and_slide()
