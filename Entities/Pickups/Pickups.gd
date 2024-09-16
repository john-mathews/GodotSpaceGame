class_name Pickup extends Node2D

@export var item: Collectible

func _ready() -> void:
	var instance = item.scene.instantiate()
	add_child(instance)

func _on_body_entered(body: Node2D) -> void:
	if body is Player && body.has_method("collect_item"):
		body.collect_item(item)
		queue_free()
