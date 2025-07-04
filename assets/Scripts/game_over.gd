extends Node2D

@onready var cherry_score: Label = $PointsPanel/PointsLabel
@export var target_level : PackedScene
@onready var t_points: RichTextLabel = $TPoints/TPoints
	
func _ready() -> void:
	var final_points: String = GameManager.check_zero_add_zero()
	cherry_score.text =str(GameManager.cherries)
	t_points.text = final_points
	GameManager.reset_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var _v1 = delta
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_packed(target_level)
