extends Control

@onready var lives = $Lives
@onready var distance_label = $Control/DistanceLabel

var uiLife_scene = preload("res://UI/HUD/ui_life.tscn")

func init_lives(amount):
	for ul in lives.get_children():
		ul.queue_free()
	for i in amount:
		var ul = uiLife_scene.instantiate()
		lives.add_child(ul)

func set_distance_label(current_dist: float) -> void:
	distance_label.text = 'Distance: ' + str(floor(current_dist))
