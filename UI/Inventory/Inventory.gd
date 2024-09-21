class_name Inventory extends Node

signal update_ui(item:Collectible)

var _content: Array[Collectible] = []

func add_item(item:Collectible):
	_content.append(item)
	update_ui.emit(item)

func remove_item(item:Collectible):
	_content.erase(item)
	update_ui.emit(item)
	
func get_items() -> Array[Collectible]:
	return _content
	
func get_item_count(item: Collectible) -> int:
	return _content.count(item)
