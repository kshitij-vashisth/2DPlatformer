extends Node

var points:int = 0
var lives:int = 3

#inventory===========================================
var has_gun: bool = false
var has_sword: bool = false
var has_tome: bool = false
var gun_ammo: int = 0
var sword_strikes: int = 0
var tome_spells: int = 0
var current_weapon_index: int = 0

var inventory = [gun_ammo, sword_strikes, tome_spells]
#======================================================

#SpawningMethods=======================================
func spawn_gun(pos) -> void:
	var GunScene = preload("res://Scenes/weapons/pistol_powerup.tscn")
	var gun = GunScene.instantiate()
	gun.global_position = pos
	get_tree().current_scene.add_child(gun)
	#get_tree().root.add_child(gun)
#======================================================
