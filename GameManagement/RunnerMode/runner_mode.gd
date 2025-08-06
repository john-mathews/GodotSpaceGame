extends Game


func getAsteroidSpawnPos():
	print('runner mode')
	# limit below 1 so they aren't a perfect line
	var point = (Vector2.RIGHT * asteroid_spawn_radius * 2) + player.global_position
	point.y = randf_range(player.global_position.y - 300.0, player.global_position.y + 300.0,)
	return point
