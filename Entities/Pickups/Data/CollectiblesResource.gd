class_name Collectible
extends Resource

enum CollectibleTypes {
	RESOURCE,
	CURRENCY,
	POWERUP
}

@export var name: String
@export var type: CollectibleTypes = CollectibleTypes.RESOURCE
#@export var scene: PackedScene
@export var value: int
@export var sprite_path: String
