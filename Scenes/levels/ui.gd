extends CanvasLayer  # or Control

@onready var points_label: Label = %PointsLabel
@export var hearts: Array[Node]

func _ready() -> void:
	update_ui()

func _game_over() -> void:
	GameManager.points = 0
	GameManager.lives = 3
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")

func decrease_health() -> void:
	GameManager.lives -= 1
	print("Lives left:", GameManager.lives)
	update_hearts()
	if GameManager.lives == 0:
		call_deferred("_game_over")

func add_points() -> void:
	GameManager.points += 1
	update_points()

func update_points() -> void:
	if points_label:
		points_label.text = str(GameManager.points)

func update_hearts() -> void:
	for h in 3:
		if h < GameManager.lives:
			hearts[h].show()
		else:
			hearts[h].hide()

func update_ui() -> void:
	update_points()
	update_hearts()
