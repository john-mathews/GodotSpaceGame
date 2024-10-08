extends Node2D

signal get_player(beam: Node2D)
var player: Player
var is_active:= true
@onready var range_collider = $Area2D/CollisionShape2D
@onready var effect = $TractorBeamEffect

var beam_range:= 100
@export var data: TractorBeamData:
	set(value):
		data = value
		set_data()

func _ready() -> void:
	set_data()
	get_player.emit(self)
	
func set_data():
	if data != null:
		if range_collider != null:
			range_collider.shape.radius = data.beam_range
		#the effect is scaled down so that is why multiply
		if effect != null:
			effect.process_material.emission_ring_radius = data.beam_range * 4
			effect.process_material.emission_ring_inner_radius = data.beam_range * 2
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Pickup && is_active:
		area.caught = true
		area.target = self
		
func set_player(value: Player) -> void:
	player = value
	
func _process(delta: float) -> void:
	if player != null:
		rotation = -player.rotation
		
	if !is_active:
		visible = false
