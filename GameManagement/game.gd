class_name Game extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player
@onready var asteroids = $Asteroids
@onready var game_over = $UI/GameOverScreen
@onready var hud = $UI/HUD
@onready var player_spawn = $SpawnArea
@onready var laser_sound = $LaserSound
@onready var explode_sound = $AsteroidHitSound
@onready var player_die_sound = $PlayerHit
@onready var spawn_timer = $AsteroidSpawnTimer
@onready var drop_list = $Drops

var asteroid_spawns:= [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

var new_asteroid_scene := preload("res://Entities/SpaceObjects/Asteroid/character_asteroid.tscn")
		
@export var asteroid_spawn_radius := 800.0
@export var asteroid_spawn_max_velocity := 50.0

func _ready():	
	hud.init_lives(player.starting_health)
	game_over.visible = false
	player.weapon.connect("laser_shot", _on_player_laser_shot)
	player.connect("damaged", _on_player_damaged)
	player_spawn.position = player.start_pos
	spawn_asteroid(getAsteroidSpawnPos(), Asteroid.AsteroidSize.LARGE, 1)
	
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)

func _on_player_laser_shot(laser):
	lasers.add_child(laser)
	laser_sound.play()

func _on_asteroid_exploded(pos: Vector2, size: Asteroid.AsteroidSize, drop: Pickup):
	explode_sound.play()
	drop.global_position = pos
	drop_list.call_deferred("add_child", drop)
	match size:
		Asteroid.AsteroidSize.LARGE:
			spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM,2)
		Asteroid.AsteroidSize.MEDIUM:
			spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL, 2)
		Asteroid.AsteroidSize.SMALL:
			pass
			#spawn_asteroid(pos, Asteroid.AsteroidSize.TINY, randi_range(3,6)) 
		Asteroid.AsteroidSize.TINY:
			pass

func spawn_asteroid(pos: Vector2, size: Asteroid.AsteroidSize, amount := 2):
	asteroid_spawns.shuffle()
	for i in amount:
		var offset:= Vector2.ZERO
		var new_asteroid = new_asteroid_scene.instantiate()
		if i < asteroid_spawns.size():
			offset = asteroid_spawns[i] * 20
			new_asteroid.velocity = asteroid_spawns[i] * 50 + Vector2(abs(player.velocity.x), 0.0)
			
		new_asteroid.global_position = pos + offset
		new_asteroid.size = size
		if size == Asteroid.AsteroidSize.LARGE: 
			new_asteroid.max_velocity = asteroid_spawn_max_velocity
			new_asteroid.look_at(player.global_position + (player.velocity.normalized() * randf_range(0, asteroid_spawn_radius)))
		new_asteroid.connect("exploded", _on_asteroid_exploded)
		asteroids.call_deferred("add_child", new_asteroid)
	
func _on_player_damaged():
	if !player.alive:
		player_spawn.global_position = player.global_position
		hud.init_lives(player.health) 
		player_die_sound.play()
		if player.health <= 0:
			await get_tree().create_timer(.3).timeout
			game_over.visible = true
			player.set_inactive()
		else:
			player.respawn()

func _on_asteroid_spawn_timer_timeout() -> void:
	spawn_asteroid(getAsteroidSpawnPos(), Asteroid.AsteroidSize.LARGE, 1)
	spawn_timer.wait_time = randf_range(.2, 2.0)

func getAsteroidSpawnPos():
	# limit below 1 so they aren't a perfect line
	var movement_angle = player.rotation + player.get_angle_to(player.velocity.normalized() + player.global_position)
	var velocity_pct = clamp(abs(player.velocity.length() / player.thruster.max_velocity), 0, .75) 
	var rotation_range = PI - (velocity_pct * PI) 
	var rand_rotate = movement_angle + randf_range(-rotation_range, rotation_range)
	var rotated_vector = Vector2(0,-1).rotated(rand_rotate).normalized()
	var point = (rotated_vector * asteroid_spawn_radius) + player.global_position
	return point
