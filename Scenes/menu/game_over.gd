extends Node2D

@onready var score_2: RichTextLabel = $Background/Score/Score2
@export var target_level : PackedScene

func _ready() -> void:
	score_2.text =str(GameManager.points)
	GameManager.points = 0
	GameManager.lives = 3
	GameManager.gun_ammo = 0
	GameManager.sword_strikes = 0
	GameManager.tome_spells = 0
	GameManager.current_weapon_index = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var _v1 = delta
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_packed(target_level)
