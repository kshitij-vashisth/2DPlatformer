extends Node2D

@onready var score_2: RichTextLabel = $Background/Score/Score2
@export var target_level : PackedScene

func _ready() -> void:
	score_2.text =str(GameManager.points)
	GameManager.points = 0
	GameManager.lives = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_packed(target_level)
