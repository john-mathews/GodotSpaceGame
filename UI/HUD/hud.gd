extends Control

@onready var lives = $Lives

var uiLife_scene = preload("res://UI/HUD/ui_life.tscn")

@onready var score = $Score:
	set(value):
		score.text = "SCORE: " + str(value) 

func init_lives(amount):
	for ul in lives.get_children():
		ul.queue_free()
	for i in amount:
		var ul = uiLife_scene.instantiate()
		lives.add_child(ul)
