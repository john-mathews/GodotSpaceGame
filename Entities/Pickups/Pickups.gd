class_name Pickup extends Area2D

@export var item: Collectible
var movement_vector:= Vector2(1,1)
var max_speed = 25
var min_speed = 10
var speed = 20
var caught := false
var target: Node2D
@onready var beam_effect := $TractorBeamEffect

func _ready() -> void:
	beam_effect.emitting = false
	speed = randi_range(min_speed, max_speed)
	var sprite = Sprite2D.new()
	sprite.texture = load(item.sprite_path)
	add_child(sprite)
	#var instance = item.scene.instantiate()
	#add_child(instance)

func _on_body_entered(body: Node2D) -> void:
	if body is Player && body.has_method("collect_item"):
		body.collect_item(item)
		queue_free()
		
func _physics_process(delta: float) -> void:
	if caught && target != null:
		if !beam_effect.emitting:
			beam_effect.emitting = true
		movement_vector = (target.global_position - global_position).normalized()
		speed += 2

	global_position += movement_vector * speed * delta
	var degrees_to_rotate = movement_vector.x/abs(movement_vector.x)
	rotate(deg_to_rad(degrees_to_rotate))
	
func _on_off_screen_kill_timer_kill_parent() -> void:
	queue_free()
