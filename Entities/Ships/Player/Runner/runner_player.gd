class_name RunnerPlayer extends Player

const INIT_ACCELERATION := 5.0
var accleration := INIT_ACCELERATION
var max_speed_achieved := 0.0
const STRAFE := 250.0
@onready var camera := $Camera2D
@onready var shield := $ShipParts/Shield
#using vectors to store values of speed acceleration map
#x is max speed and y is acceleration
var speed_acceleration_map := [Vector2(25,50), Vector2(100, 25), Vector2(250,10), Vector2(1000,5), Vector2(1500,2)]


func _ready() -> void:
	super()
	
func _process(delta: float) -> void:
	if health <= 0: return
	
	#if !weapon.shoot_cd:
		#weapon.shoot_pressed(velocity)

func _physics_process(delta: float) -> void:
	if velocity.x < max_speed_achieved:
		accleration = 50
	else:
		for speed_key in speed_acceleration_map:
			if velocity.x < speed_key.x:
				accleration = speed_key.y
				break
			elif speed_key == speed_acceleration_map[-1]:
				accleration = 1
	velocity.x += (delta * accleration)
	
	var input_vector := Vector2(0, Input.get_axis("move_forward","move_backward"))
	if position.y > (camera.limit_top + 25) && input_vector.y < 0:
		velocity.y = input_vector.y * STRAFE 
	elif position.y < (camera.limit_bottom - 25) && input_vector.y > 0:
		velocity.y = input_vector.y * STRAFE 
	else:
		velocity.y = 0
	
	if velocity.x > max_speed_achieved: 
		max_speed_achieved = velocity.x
		
	move_and_slide()
	
	var collision = get_last_slide_collision()
	if collision != null:
		var normal := collision.get_normal()
		print(normal)
		var angle := collision.get_angle()
		print(angle)
		print(rad_to_deg(angle))
		#if alive && collision != null && collision.get_collider() is RigidBody2D:
			#var collider := collision.get_collider() as Asteroid
			#collider.apply_force(velocity - collider.linear_velocity, collision.get_position())

			#velocity.bounce(normal)
			#if abs(angle) < 60:
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
		var current_velocity = velocity
		body.apply_central_impulse(velocity)	
		velocity = velocity.normalized() * -25
		shield.hide()
		accleration = current_velocity.x / 5
		await get_tree().create_timer(5).timeout
		accleration = INIT_ACCELERATION
	
