extends Node2D

signal laser_shot(laser)

var fire_rate := .8
var burst_amount:= 3

var laser_scene = preload("res://Entities/Ships/ShipParts/Weapons/Laser/laser.tscn")
var shoot_cd := false
@onready var muzzle = $Muzzle

@export var laser_data: LaserWeaponData:
	set(value):
		laser_data = value
		set_data()

func set_data():
	if laser_data != null:
		fire_rate = laser_data.fire_rate
		burst_amount = laser_data.burst_amount
			
func shoot_pressed() -> void:
	if !shoot_cd:
		shoot_cd = true
		for i in burst_amount:
			shoot_laser()
			await get_tree().create_timer(.1).timeout
		await get_tree().create_timer(fire_rate).timeout
		shoot_cd = false

func shoot_laser():
	var laser_inst = laser_scene.instantiate()
	if laser_data != null:
		laser_inst.attack_power = laser_data.weapon_power
	laser_inst.global_position = muzzle.global_position
	laser_inst.rotation = global_rotation
	emit_signal("laser_shot", laser_inst)
