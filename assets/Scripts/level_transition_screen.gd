extends Node


@onready var world: RichTextLabel = $UI/WorldInformation/World
@onready var points_label: Label = $UI/PointsPanel/PointsLabel
@onready var lives: RichTextLabel = $UI/Lives

func load_level(level_name: String) -> void:
	var path = "res://assets/Scenes/levels/%s.tscn" % level_name
	get_tree().change_scene_to_file(path)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world.text = str(GameManager.level_list[GameManager.level_index])
	points_label.text = str(GameManager.points)
	lives.text = str(GameManager.lives)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await get_tree().create_timer(3).timeout
	load_level(GameManager.level_changer_list[GameManager.level_index])
