extends Node

var hearts: int = 3
var points: int = 0
var lives: int = 3
var cherries: int = 0
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
func check_zero_add_zero() -> String:
	var num_zeros: int = 7-len(str(points))
	var final_points: String = ""
	for i in range(num_zeros):
		final_points += str(0)
	final_points += str(GameManager.points)
	return final_points  



#SpawningMethods=======================================
func spawn_gun(pos) -> void:
	var GunScene = preload("res://assets/Scenes/weapons/pistol_powerup.tscn")
	var gun = GunScene.instantiate()
	gun.global_position = pos
	get_tree().current_scene.add_child(gun)
	#get_tree().root.add_child(gun)
#======================================================

func reset_game() -> void:
	cherries = 0
	points = 0
	hearts = 3
	lives = 3
	gun_ammo = 0
	sword_strikes = 0
	tome_spells = 0
	current_weapon_index = 0
	level_index = 0
