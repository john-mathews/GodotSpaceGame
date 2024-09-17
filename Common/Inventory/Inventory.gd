class_name Inventory

var _content: Array[Collectible] = []

func add_item(item:Collectible):
	_content.append(item)

func remove_item(item:Collectible):
	_content.erase(item)
	
func get_items() -> Array[Collectible]:
	return _content
	
