extends Node2D

@onready var noob_text: RichTextLabel = $Noob_text
@onready var cherry_score: Label = $PointsPanel/PointsLabel
@export var target_level : PackedScene
@onready var t_points: RichTextLabel = $TPoints/TPoints
	
func _ready() -> void:
	if GameManager.level_1_1_loaded == 0:
		noob_text.show()
	else:
		noob_text.hide()
	var final_points: String = GameManager.check_zero_add_zero()
	cherry_score.text =str(GameManager.cherries)
	t_points.text = final_points
	GameManager.reset_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var _v1 = delta
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_packed(target_level)
