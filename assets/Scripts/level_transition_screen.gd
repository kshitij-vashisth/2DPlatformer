extends Node


@onready var world: RichTextLabel = $UI/WorldInformation/World
@onready var cherries_label: Label = $UI/PointsPanel/PointsLabel
@onready var lives: RichTextLabel = $UI/Lives
@onready var t_points: RichTextLabel = $UI/TPoints/TPoints

func load_level(level_name: String) -> void:
	var path = "res://assets/Scenes/levels/%s.tscn" % level_name
	get_tree().change_scene_to_file(path)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.level_index == 3 and GameManager.level_1_1_loaded == 0:
		GameManager.level_1_1_loaded += 1
		GameManager.reset_game_soft()
	var final_points: String = GameManager.check_zero_add_zero()
	world.text = str(GameManager.level_list[GameManager.level_index])
	cherries_label.text = str(GameManager.cherries)
	lives.text = str(GameManager.lives)
	t_points.text = final_points

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var _v: float = delta
	await get_tree().create_timer(3).timeout
	load_level(GameManager.level_changer_list[GameManager.level_index])
