extends Node

var sprite_list := []
var selected_sprite: Sprite2D

func select_sprite() -> String:
	for child in get_children():
		if child is Sprite2D:
			sprite_list.push_back(child)
	
	selected_sprite = sprite_list.pick_random()
	return selected_sprite.texture.resource_path
