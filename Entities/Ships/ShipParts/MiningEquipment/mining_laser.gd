extends RayCast2D

@onready var beam = $Line2D
@onready var laser_range = $LaserRange
@onready var laser_range_collider = $LaserRange/CollisionShape2D
@onready var start_effect = $Effects/StartEffect
@onready var end_effect = $Effects/EndEffect
@onready var damage_effect = $Effects/DamageEffect

@export var mining_power:= 1.0
@export var mining_rate:= 1.0

var target: Node2D #Node2D so we can make it anything
var locked_to_target := false
var laser_lock_tween: Tween
var new_target_timer: SceneTreeTimer
var damage_timer: SceneTreeTimer

var is_casting := false:
	set(value):
		is_casting = value
		set_is_casting(value)
	
var asteroids_in_range: Array[Node2D] = []:
	get():
		if laser_range != null:
			return laser_range.get_overlapping_bodies()
		else:
			return []

var cast_point: Vector2

func _ready() -> void:
	target_position = Vector2(laser_range_collider.shape.radius, 0)
	

func _process(delta: float) -> void:
	if target != null && locked_to_target && (new_target_timer == null || new_target_timer.time_left == 0):
		look_at(target.global_position)
		is_casting = true
	else:
		is_casting = false
		
		
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		if get_collider() is Asteroid:
			damage_asteroid(get_collider())
	
	set_effects(is_casting, cast_point)
	beam.points[1] = cast_point
	set_locked_to_target()
	

func set_is_casting(cast: bool) -> void:
	if cast:
		appear()
	else:
		disappear()
	set_physics_process(cast)
	
	
func appear():
	var tween = get_tree().create_tween()
	tween.tween_property(beam, "visible", true, 0)
	tween.tween_property(beam, "width", 5.0, 1)
	
func disappear():
	var tween = get_tree().create_tween()
	tween.tween_property(beam, "width", 1, .5)
	tween.tween_property(beam, "visible", false, 0)


#func _on_laser_range_area_entered(area: Area2D, get_new_taget:= false) -> void:
	#if ((new_target_timer == null || new_target_timer.time_left == 0) && 
	#area is Asteroid && 
	#(target == null || target not in asteroids_in_range || get_new_taget)):
		#target = area
		#new_target_timer = get_tree().create_timer(.5)


func set_effects(toggle: bool, laser_pos:= Vector2.ZERO):
	end_effect.position = laser_pos
	damage_effect.position = laser_pos
	
	start_effect.emitting = toggle
	start_effect.visible = toggle
	end_effect.emitting = toggle
	end_effect.visible = toggle

#func _on_laser_range_area_exited(area: Area2D) -> void:
	#if area == target:
		#target = null
		#set_locked_to_target(false)
		
func acquire_new_target():
	for body in asteroids_in_range:
		_on_laser_range_body_entered(body, true)
		continue
		
func damage_asteroid(asteroid: Asteroid):
	if damage_timer == null || damage_timer.time_left == 0:
		if asteroid.health > mining_power:
			damage_effect.restart()
			damage_effect.visible = true
			damage_effect.emitting = true
		damage_timer = get_tree().create_timer(mining_rate)
		asteroid.take_damage(mining_power)


		
		
func set_locked_to_target(locked: bool = true):
	if locked && is_colliding() && get_collider() == target:
		locked_to_target = true
	elif target != null && target in asteroids_in_range:
		locked_to_target = true
	elif target == null && asteroids_in_range.size() > 0:
		locked_to_target = false
		acquire_new_target()
	else:
		locked_to_target = false
		target = null
	


func _on_laser_range_body_entered(body: Node2D, get_new_taget:= false) -> void:
	if ((new_target_timer == null || new_target_timer.time_left == 0) && 
	body is Asteroid && 
	(target == null || target not in asteroids_in_range || get_new_taget)):
		target = body
		new_target_timer = get_tree().create_timer(.5)


func _on_laser_range_body_exited(body: Node2D) -> void:
		if body == target:
			target = null
			set_locked_to_target(false)
