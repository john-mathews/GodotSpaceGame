extends Control

var inventory_item_scene = preload("res://UI/Inventory/inventory_item.tscn")
@onready var container = $HBoxContainer


func _ready() -> void:
	PlayerInventory.connect("update_ui", _on_resource_collected)
		
func _on_resource_collected(item: Collectible):
	var item_count = PlayerInventory.get_item_count(item)
	var child = find_item_child(item)
	
	if item_count == 0 && child != null:
		child.queue_free()
	elif item_count == 1 && child == null:
		var scene = inventory_item_scene.instantiate()
		scene.item = item
		container.add_child(scene)
		
	if child != null:
		child.item_count = item_count
		
	
func find_item_child(item: Collectible) -> InventoryItem:
	var children = container.get_children()
	var found_child = null
	for child in children:
		if child is InventoryItem && child.item == item:
			found_child = child
	
	return found_child
			
