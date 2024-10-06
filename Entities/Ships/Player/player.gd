class_name Player extends CharacterBody2D

signal damaged()

#region Variables
@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D
@onready var thruster_effect = $ShipParts/Engine/GPUParticles2D
@onready var thruster = $ShipParts/Engine
@onready var weapon = $ShipParts/Weapons
@onready var mining_laser = $ShipParts/MiningLaser
@onready var tractor_beam = $ShipParts/TractorBeam

var alive := true
var start_pos: Vector2
@export var starting_health = 3
@export var thruster_level = 0
@export var laser_weapon_level = 0
@export var mining_laser_level = 0
@export var tractor_beam_level = 0

var health : int:
	set(value):
		health = value

#endregion

func _ready() -> void:
	setup_ship()
	start_pos = global_position
	health = starting_health
	
func _process(delta: float) -> void:
	if health <= 0: return
	
	if Input.is_action_pressed("shoot"):
		weapon.shoot_pressed()

func _physics_process(delta: float) -> void:
	if health <= 0: return
	
	var input_vector := Vector2(0, Input.get_axis("move_forward","move_backward"))
	velocity += input_vector.rotated(rotation) * thruster.acceleration
	velocity = velocity.limit_length(thruster.max_velocity)
	
	if input_vector.y == 0:
		thruster_effect.emitting = false
		velocity = velocity.move_toward(Vector2.ZERO, 4)
	else:
		thruster_effect.emitting = true
	
	if Input.is_action_pressed("roatate_clockwise"):
		rotate(deg_to_rad(thruster.rotation_speed*delta))
	elif Input.is_action_pressed("rotate_counter_clockwise"):
		rotate(deg_to_rad(thruster.rotation_speed*delta*-1))
		
	var collision = move_and_collide(velocity * delta)
	if alive && collision != null && collision.get_collider() is Asteroid:
		die()
	
func die():
	if alive:
		alive = false
		health -= 1
		emit_signal("damaged")

func respawn():
	if !alive:
		var flash_tween = get_tree().create_tween().set_loops(5)
		
		flash_tween.tween_property(sprite, "modulate:a", .1, .3)
		flash_tween.parallel().tween_property(thruster, "modulate:a", .1, .3)
		
		flash_tween.tween_property(sprite, "modulate:a", 1, .3)
		flash_tween.parallel().tween_property(thruster, "modulate:a", 1, .3).set_delay(.2)
		flash_tween.connect("finished", make_alive)
		
func make_alive():
	alive = true		

func setup_ship():
	thruster.data = load(GameState.thruster_tiers[thruster_level])
	weapon.laser_data = load(GameState.laser_weapon_tiers[laser_weapon_level])
	mining_laser.data = load(GameState.mining_laser_tiers[mining_laser_level])
	tractor_beam.data = load(GameState.tractor_beam_tiers[tractor_beam_level])

func collect_item(item: Collectible):
	PlayerInventory.add_item(item)
	
func _on_tractor_beam_get_player(beam: Node2D) -> void:
	beam.set_player(self)

func set_inactive() -> void:
	mining_laser.is_active = false
	tractor_beam.is_active = false
	thruster.visible = false
