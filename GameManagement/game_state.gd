extends Node

var star_drop_resource_paths: Array[Collectible] = []

var thruster_tiers = []
var player_thruster_level = 0

var mining_laser_tiers: Array[MiningLaserData] = []
var player_mining_laser_level = 0

var laser_weapon_tiers: Array[LaserWeaponData] = []
var player_laser_weapon_level = 0

var tractor_beam_tiers: Array[TractorBeamData] = []
var player_tractor_beam_level = 0

func _ready() -> void:
	star_drop_resource_paths = ResourceLister.getResourcesByPath("res://Entities/Pickups/Data/StarData/")
	
	mining_laser_tiers = ResourceLister.getResourcesByPath("res://Entities/Ships/ShipParts/MiningEquipment/Data/")
	laser_weapon_tiers = ResourceLister.getResourcesByPath("res://Entities/Ships/ShipParts/Weapons/Laser/Data/")
	tractor_beam_tiers = ResourceLister.getResourcesByPath("res://Entities/Ships/ShipParts/TractorBeam/Data/")
	
