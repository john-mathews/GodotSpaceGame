extends Node

var star_drop_resource_paths = []

func _ready() -> void:
	star_drop_resource_paths = resource_lister.getResourcesByPath("res://Entities/Pickups/Data/StarData/")
	
