extends Node2D
var acceleration := 8.0
var max_velocity := 300.0
var rotation_speed := 200.0
@export var data: ThrusterData:
	set(value):
		data = value
		set_data()
		
func _ready() -> void:
	set_data()

func set_data():
	if data != null:
		acceleration = data.acceleration
		max_velocity = data.max_velocity
		rotation_speed = data.rotation_speed
			
