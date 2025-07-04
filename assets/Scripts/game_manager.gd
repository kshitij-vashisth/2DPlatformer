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

var inventory: Array = [gun_ammo, sword_strikes, tome_spells]
#======================================================

#LevelTransitionUtilities==============================
var level_list: Array = [
	"Tutorial-1", "Tutorial-2", "Tutorial-3",
	"World 1-1",
]
var level_index: int = 0
var level_changer_list: Array = [
	"Level_0_1","Level_0_2","Level_0_3",
	"Level_1_1",
]
#======================================================




#SpawningMethods=======================================
func spawn_gun(pos) -> void:
	var GunScene = preload("res://assets/Scenes/weapons/pistol_powerup.tscn")
	var gun = GunScene.instantiate()
	gun.global_position = pos
	get_tree().current_scene.add_child(gun)
	#get_tree().root.add_child(gun)
#======================================================
