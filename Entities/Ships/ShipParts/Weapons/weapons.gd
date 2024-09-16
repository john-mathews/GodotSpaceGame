extends Node2D

signal laser_shot(laser)

@export var fire_rate := .4

var laser_scene = preload("res://Entities/Ships/ShipParts/Weapons/Laser/laser.tscn")
var shoot_cd := false
@onready var muzzle = $Muzzle

			
func shoot_pressed() -> void:
	if !shoot_cd:
		shoot_cd = true
		shoot_laser()
		await get_tree().create_timer(fire_rate).timeout
		shoot_cd = false

func shoot_laser():
	var laser_inst = laser_scene.instantiate()
	laser_inst.global_position = muzzle.global_position
	laser_inst.rotation = global_rotation
	emit_signal("laser_shot", laser_inst)
