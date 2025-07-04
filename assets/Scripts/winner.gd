extends Node2D

@onready var cherry_label: Label = $CanvasLayer/PointsPanel/PointsLabel
@onready var final_score: RichTextLabel = $CanvasLayer/TPoints/FinalScore

@export var target_level : PackedScene

func _ready() -> void:
	var final_points: String = GameManager.check_zero_add_zero()
	final_score.text = final_points
	cherry_label.text = str(GameManager.cherries)
	GameManager.reset_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var _v1 = delta
	await get_tree().create_timer(5.8).timeout
	get_tree().change_scene_to_packed(target_level)
