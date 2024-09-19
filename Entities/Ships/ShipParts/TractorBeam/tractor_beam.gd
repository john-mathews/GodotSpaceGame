extends Node2D

signal get_player(beam: Node2D)
var player: Player

func _ready() -> void:
	get_player.emit(self)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Pickup:
		area.caught = true
		area.target = self
		
func set_player(value: Player) -> void:
	player = value
	
func _physics_process(delta: float) -> void:
	if player != null:
		rotation = -player.rotation
