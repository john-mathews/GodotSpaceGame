class_name RunnerPlayer extends Player

const INIT_ACCELERATION := 5.0
var accleration := INIT_ACCELERATION
const STRAFE := 250.0
@onready var camera := $Camera2D
@onready var shield := $ShipParts/Shield

func _ready() -> void:
	super()
	
	accleration = 25
	await get_tree().create_timer(5.0).timeout
	accleration = INIT_ACCELERATION

func _process(delta: float) -> void:
	if health <= 0: return
	
	if !weapon.shoot_cd:
		weapon.shoot_pressed(velocity)

func _physics_process(delta: float) -> void:
	velocity.x += (delta * accleration)
	
	var input_vector := Vector2(0, Input.get_axis("move_forward","move_backward"))
	if position.y > (camera.limit_top + 25) && input_vector.y < 0:
		velocity.y = input_vector.y * STRAFE 
	elif position.y < (camera.limit_bottom - 25) && input_vector.y > 0:
		velocity.y = input_vector.y * STRAFE 
	else:
		velocity.y = 0
	
	move_and_slide()

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
	
