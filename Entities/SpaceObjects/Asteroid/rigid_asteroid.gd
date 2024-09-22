class_name Asteroid extends RigidBody2D

signal exploded(pos, size, points, drop)
enum AsteroidSize{LARGE, MEDIUM, SMALL, TINY}

#region Variables
var movement_vector := Vector2(1, 0)

@export var size := AsteroidSize.LARGE
@export var health := 5
@export var max_velocity := 50.0

var speed := 100
var texture_to_load: String
var health_bar_offset: int

var points: int:
	get:
		match size:
			AsteroidSize.LARGE:
				return 150
			AsteroidSize.MEDIUM:
				return 100
			AsteroidSize.SMALL:
				return 75
			AsteroidSize.TINY:
				return 50
			_:
				return 0

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var large_sprite_picker = $SpritePickers/RngSpritePickerListLarge
@onready var medium_sprite_picker = $SpritePickers/RngSpritePickerListMedium
@onready var small_sprite_picker = $SpritePickers/RngSpritePickerListSmall
@onready var tiny_sprite_picker = $SpritePickers/RngSpritePickerListTiny
@onready var health_bar = $ProgressBar
var pickup: Pickup
#endregion

func _ready() -> void:
	if size != AsteroidSize.LARGE:
		rotation = randf_range(0, 2 * PI)
	sprite.rotation = randf_range(0, 2 * PI)
	linear_velocity = movement_vector.rotated(rotation) * max_velocity
	var resource_path = GameState.star_drop_resource_paths.pick_random()
	var imported_resouce = load(resource_path)
	pickup = preload("res://Entities/Pickups/Pickups.tscn").instantiate()
	pickup.item = imported_resouce
	
	match size:
		AsteroidSize.LARGE:
			max_velocity = randi_range(40,80)
			health = 5
			mass = 50
			health_bar_offset = -50
			sprite.texture = load(large_sprite_picker.select_sprite())
			collision_shape.set_deferred("shape", preload("res://Entities/SpaceObjects/Asteroid/Resources/asteroid_collision_L.tres"))
		AsteroidSize.MEDIUM:
			max_velocity = randi_range(50, 100)
			health = 3
			mass = 30
			health_bar_offset = -20
			sprite.texture = load(medium_sprite_picker.select_sprite())
			collision_shape.set_deferred("shape", preload("res://Entities/SpaceObjects/Asteroid/Resources/asteroid_collision_M.tres"))
		AsteroidSize.SMALL:
			max_velocity = randi_range(70, 120)
			health = 1
			mass = 20
			health_bar_offset = -10
			sprite.texture = load(small_sprite_picker.select_sprite())
			collision_shape.set_deferred("shape", preload("res://Entities/SpaceObjects/Asteroid/Resources/asteroid_collision_S.tres"))
		AsteroidSize.TINY:
			health = 1
			mass = 10
			max_velocity = randi_range(25, 150)
			health_bar_offset = -5
			sprite.texture = load(tiny_sprite_picker.select_sprite())
			collision_shape.set_deferred("shape", preload("res://Entities/SpaceObjects/Asteroid/Resources/asteroid_collision_S.tres"))
	health_bar.max_value = health
	update_health_bar()

func update_health_bar():
	health_bar.value = health
	
func position_health_bar():
	health_bar.rotation = -rotation

func _physics_process(delta: float) -> void:
	var movement = linear_velocity.normalized() * max_velocity * delta
	position_health_bar()
	apply_central_impulse(movement)
		
func take_damage(damage: int):
	health -= damage
	update_health_bar()
	if (health <= 0):
		pickup.movement_vector = linear_velocity.normalized()
		emit_signal("exploded", global_position, size, pickup)
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player && body.alive:
		var player = body
		player.die()

func _on_off_screen_kill_timer_kill_parent() -> void:
	queue_free()
