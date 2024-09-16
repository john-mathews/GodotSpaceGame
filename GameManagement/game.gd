extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player
@onready var asteroids = $Asteroids
@onready var hud = $Player/UI/HUD
@onready var game_over = $Player/UI/GameOverScreen
@onready var player_spawn = $SpawnArea
@onready var laser_sound = $LaserSound
@onready var explode_sound = $AsteroidHitSound
@onready var player_die_sound = $PlayerHit
@onready var spawn_timer = $AsteroidSpawnTimer
@onready var drop_list = $Drops

#var asteroid_scene = preload("res://Scenes/asteroid.tscn")
var new_asteroid_scene := preload("res://Entities/SpaceObjects/Asteroid/rigid_asteroid.tscn")
var score := 0:
	set(value):
		score = value
		hud.score = score
		
@export var starting_lives = 3
@export var asteroid_spawn_radius = 700

var lives : int:
	set(value):
		lives = value
		hud.init_lives(value) 

func _ready():
	spawn_asteroid(getAsteroidSpawnPos(), Asteroid.AsteroidSize.LARGE, 1)
	lives = starting_lives
	score = 0
	game_over.visible = false
	player.weapon.connect("laser_shot", _on_player_laser_shot)
	player.connect("died", _on_player_died)
	player_spawn.position = player.start_pos
	
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)

func _on_player_laser_shot(laser):
	lasers.add_child(laser)
	laser_sound.play()

func _on_asteroid_exploded(pos: Vector2, size: Asteroid.AsteroidSize, points: int, drop: Pickup):
	score += points
	explode_sound.play()
	drop.global_position = pos
	drop_list.call_deferred("add_child", drop)
	match size:
		Asteroid.AsteroidSize.LARGE:
			spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM, randi_range(2,3))
		Asteroid.AsteroidSize.MEDIUM:
			spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL, randi_range(2,5))
		Asteroid.AsteroidSize.SMALL:
			spawn_asteroid(pos, Asteroid.AsteroidSize.TINY, randi_range(3,6)) 
		Asteroid.AsteroidSize.TINY:
			pass

	
func spawn_asteroid(pos, size, amount = 2):
	for i in amount:
		var newAsteroid = new_asteroid_scene.instantiate()
		newAsteroid.global_position = pos
		newAsteroid.size = size
		if size == Asteroid.AsteroidSize.LARGE: 
			newAsteroid.look_at(player.global_position + player.velocity)
		newAsteroid.connect("exploded", _on_asteroid_exploded)
		asteroids.call_deferred("add_child", newAsteroid)
	
func _on_player_died():
	player.global_position = player.start_pos
	lives -= 1
	player_die_sound.play()
	if lives <= 0:
		await get_tree().create_timer(1).timeout
		game_over.visible = true
	else:
		await get_tree().create_timer(1).timeout
		while !player_spawn.is_empty:
			await get_tree().create_timer(.1).timeout
		player.respawn()


func _on_asteroid_spawn_timer_timeout() -> void:
	spawn_asteroid(getAsteroidSpawnPos(), Asteroid.AsteroidSize.LARGE, 1)
	if spawn_timer.wait_time > 1: spawn_timer.wait_time -= 1

func getAsteroidSpawnPos():
	var rand_rotate = randf_range(0, 2 * PI)
	var rotated_vector = Vector2(1,1).rotated(rand_rotate).normalized()
	var point = (rotated_vector * asteroid_spawn_radius) + player.global_position 
	return point
