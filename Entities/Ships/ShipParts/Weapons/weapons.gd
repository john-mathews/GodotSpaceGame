extends Node2D

signal laser_shot(laser)

var fire_rate := .8
var burst_amount:= 3
@export var data: LaserWeaponData

var laser_scene = preload("res://Entities/Ships/ShipParts/Weapons/Laser/laser.tscn")
var shoot_cd := false
@onready var muzzle = $Muzzle

func _ready() -> void:
	if data != null:
		fire_rate = data.fire_rate
		burst_amount = data.burst_amount
	
			
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
	if data != null:
		print(data.weapon_power)
		laser_inst.attack_power = data.weapon_power
	laser_inst.global_position = muzzle.global_position
	laser_inst.rotation = global_rotation
	emit_signal("laser_shot", laser_inst)
