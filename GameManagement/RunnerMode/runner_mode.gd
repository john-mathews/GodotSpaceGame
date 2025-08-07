extends Game
var initial_spawn_sizes : Array[Asteroid.AsteroidSize] = [Asteroid.AsteroidSize.LARGE, Asteroid.AsteroidSize.MEDIUM, Asteroid.AsteroidSize.SMALL]
var game_seconds := 0.0
@export var init_min_spawn := 1.0
@export var init_max_spawn := 5.0

func _process(delta: float) -> void:
	game_seconds += delta

func getAsteroidSpawnPos():
	var point = (Vector2.RIGHT * asteroid_spawn_radius) + player.global_position
	point.y = randf_range( -400.0,  400.0,)
	return point

func _on_asteroid_spawn_timer_timeout() -> void:
	var speed_level = floor(player.velocity.x/100) + 1
	for i in range(speed_level):
		spawn_asteroid(getAsteroidSpawnPos(), initial_spawn_sizes.pick_random(), 1)
	var min = max(.2, init_min_spawn - speed_level/5)
	var max = max(.5, init_max_spawn - speed_level)
	spawn_timer.wait_time = randf_range(min, max)
