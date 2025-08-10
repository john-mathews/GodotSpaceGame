class_name RunnerPlayer extends Player

const INIT_ACCELERATION := 5.0
var accleration := INIT_ACCELERATION
var max_speed_achieved := 0.0
const STRAFE_ACCEL := 2.0
const STRAFE := 250.0
const BOUNCE_VECTOR := Vector2(1.5, 1.0)
@onready var camera := $Camera2D
@onready var shield := $ShipParts/Shield
#using vectors to store values of speed acceleration map
#x is max speed and y is acceleration
var speed_acceleration_map := [Vector2(25,25), Vector2(100, 10), Vector2(250,5), Vector2(1000,2)]


func _ready() -> void:
	super()
	
func _process(delta: float) -> void:
	if health <= 0: return
	
	if !weapon.shoot_cd:
		weapon.shoot_pressed(velocity)

func _physics_process(delta: float) -> void:
	if velocity.x < max_speed_achieved:
		accleration = 50
	else:
		for speed_key in speed_acceleration_map:
			if velocity.x < speed_key.x:
				accleration = speed_key.y
				break
			else:
				accleration = 1
	velocity.x += (delta * accleration)
	
	var input_vector := Vector2(0, Input.get_axis("move_forward","move_backward"))
	if position.y > (camera.limit_top + 25) && input_vector.y < 0:
		if abs(velocity.y) < STRAFE:
			velocity.y += input_vector.y * STRAFE * delta * STRAFE_ACCEL
	elif position.y < (camera.limit_bottom - 25) && input_vector.y > 0:
		if abs(velocity.y) < STRAFE:
			velocity.y += input_vector.y * STRAFE * delta * STRAFE_ACCEL
	elif abs(position.y) > abs(camera.limit_top):
		velocity.y = 0.0
	elif input_vector.y == 0.0:
		velocity.y = lerp(velocity.y, 0.0, .05)
	
	if velocity.x > max_speed_achieved: 
		max_speed_achieved = velocity.x
		
	move_and_slide()
	
	var collision = get_last_slide_collision()
	if collision != null:
		var collider = collision.get_collider()
		#var normal := collision.get_normal()
		var angle := collision.get_angle(Vector2.LEFT)
		if collider != null && collider is Asteroid:
			var pos_diff = global_position - collider.global_position
			var max_vel = Vector2Utils.max_v2([velocity, collider.velocity]) 
			if max_vel.length() < 50: max_vel = max_vel.normalized() * 50
			
			velocity += pos_diff.normalized() * max_vel
			collider.velocity = (-pos_diff.normalized() * BOUNCE_VECTOR * max_vel.length()) 
			
			#velocity.bounce(normal)
		if alive:
			var deg = abs(rad_to_deg(angle))
			if deg < 30 || deg > 330:
				pass
				#die()

func collect_item(item: Collectible):
	if item.type == Collectible.CollectibleTypes.RESOURCE:
		PlayerInventory.add_item(item)
	elif item.type == Collectible.CollectibleTypes.POWERUP:
		pass
	elif item.type == Collectible.CollectibleTypes.CURRENCY:
		pass
	else:
		print_debug('Collectible type not defined')

func _on_shield_body_entered(body: Node2D) -> void:
	if shield.visible && body is Asteroid:
		set_body_velocity(body)
		velocity = velocity.normalized() * -25
		shield.hide()
	
func set_body_velocity(body: Asteroid) -> void:
		var pos_diff = body.global_position - global_position
		body.velocity = (pos_diff.normalized() * velocity.length())
	
