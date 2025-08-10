extends Game

var initial_spawn_sizes : Array[Asteroid.AsteroidSize] = [Asteroid.AsteroidSize.LARGE, Asteroid.AsteroidSize.MEDIUM, Asteroid.AsteroidSize.SMALL]
var game_seconds := 0.0
@export var init_min_spawn := 0.5
@export var init_max_spawn := 3.0
var min_min_time := 0.5
var min_max_time := 3.0
var max_distance := 0.0
var chunk_spawner := ChunkSpawner.new()
var chunk_spawn_offset: float = 0.0
var chunk_index:= 0

func _ready() -> void:
	super()
	min_min_time = init_min_spawn
	min_max_time = init_max_spawn
	add_child(chunk_spawner)
	chunk_spawn_offset = chunk_spawner.chunk_dimensions.x
	for asteroid in chunk_spawner.asteroids:
		asteroid.connect("exploded", _on_asteroid_exploded)
	

func _process(delta: float) -> void:
	game_seconds += delta
	hud.set_speed_label(player.velocity.x)
	if player.global_position.x > max_distance:
		max_distance = player.global_position.x
		hud.set_distance_label(max_distance)
		var ind = int(max_distance/chunk_spawn_offset)
		if chunk_index < ind:
			print(max_distance)
			print('spawning chunk')
			chunk_spawner.spawn_chunk(ind+1)
			chunk_index = ind

func getAsteroidSpawnPos(x_offset: float = 0.0):
	var point = (Vector2.RIGHT * asteroid_spawn_radius) + player.global_position
	point.y = randf_range( -400.0,  400.0)
	if x_offset > 0.0:
		point.x = x_offset
	return point

#func _on_asteroid_exploded(pos: Vector2, size: Asteroid.AsteroidSize, drop: Pickup):
	#explode_sound.play()
	#drop.global_position = pos
	#drop_list.call_deferred("add_child", drop)
	#match size:
		#Asteroid.AsteroidSize.LARGE:
			#print('large')
			#spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM, randi_range(1,2))
		#Asteroid.AsteroidSize.MEDIUM:
			#print('medium')
			#spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL, randi_range(2,3))
		#Asteroid.AsteroidSize.SMALL:
			#pass
			# #spawn_asteroid(pos, Asteroid.AsteroidSize.TINY, randi_range(3,6)) 
		#Asteroid.AsteroidSize.TINY:
			#pass

func _on_asteroid_spawn_timer_timeout() -> void:
	pass
	#var speed_level := int(player.velocity.x/100) + 1
	#for i in range(speed_level):
		#spawn_asteroid(getAsteroidSpawnPos(i * 100.0), initial_spawn_sizes.pick_random(), 1)
	#var max1 = max(.06, init_max_spawn - speed_level/2.0)
	#var min1 = min(max(.03, init_min_spawn - speed_level/5.0), max1)
	#min_min_time = min(min_min_time, min1)
	#min_max_time = min(min_max_time, max1)
	#spawn_timer.wait_time = randf_range(min_min_time, min_max_time)
