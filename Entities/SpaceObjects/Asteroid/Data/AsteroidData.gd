class_name AsteroidBaseData extends Resource

@export var tier:= 1
@export var size:= Asteroid.AsteroidSize.LARGE
@export var velocity:= 50
@export var health:= 50
@export var mass:= 50
@export var health_bar_offset:= -50

var collision_shape_path: String:
	get():
		match size:
			Asteroid.AsteroidSize.LARGE:
				return "res://Entities/SpaceObjects/Asteroid/Resources/asteroid_collision_L.tres"
			Asteroid.AsteroidSize.MEDIUM:
				return "res://Entities/SpaceObjects/Asteroid/Resources/asteroid_collision_M.tres"
			_:
				return "res://Entities/SpaceObjects/Asteroid/Resources/asteroid_collision_S.tres"
