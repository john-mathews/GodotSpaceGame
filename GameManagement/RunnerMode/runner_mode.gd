extends Game

var initial_spawn_sizes : Array[Asteroid.AsteroidSize] = [Asteroid.AsteroidSize.LARGE, Asteroid.AsteroidSize.MEDIUM, Asteroid.AsteroidSize.SMALL]
var game_seconds := 0.0
@export var init_min_spawn := 0.5
@export var init_max_spawn := 3.0
var min_min_time := 0.5
var min_max_time := 3.0
var max_distance := 0.0

func _process(delta: float) -> void:
	game_seconds += delta
	hud.set_speed_label(player.velocity.x)
	if player.global_position.x > max_distance:
		max_distance = player.global_position.x
		hud.set_distance_label(max_distance)

func getAsteroidSpawnPos(x_offset: float = 0.0):
	var point = (Vector2.RIGHT * asteroid_spawn_radius) + player.global_position
	point.y = randf_range( -400.0,  400.0)
	if x_offset > 0.0:
		point.x = x_offset
	return point

func _on_asteroid_spawn_timer_timeout() -> void:
	var speed_level := int(player.velocity.x/100) + 1
	for i in range(speed_level):
		spawn_asteroid(getAsteroidSpawnPos(i * 100.0), initial_spawn_sizes.pick_random(), 1)
	var max1 = max(.06, init_max_spawn - speed_level/2.0)
	var min1 = min(max(.03, init_min_spawn - speed_level/5.0), max1)
	min_min_time = min(min_min_time, min1)
	min_max_time = min(min_max_time, max1)
	spawn_timer.wait_time = randf_range(min_min_time, min_max_time)
