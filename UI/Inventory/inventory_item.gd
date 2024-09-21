class_name InventoryItem extends Control

var item: Collectible
var item_count := 0:
	set(value):
		item_count = value
		set_label(value)

@onready var texture_rect = $VBoxContainer/TextureRect
@onready var count_label = $VBoxContainer/Label

func _ready() -> void:
	var img = await load(item.sprite_path)
	texture_rect.texture = img

func set_label(count: int) -> void:
	count_label.text = str(count)
