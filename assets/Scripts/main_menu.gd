extends Node

func _ready() -> void:
	# Set the default mouse cursor shape
	Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)

func load_level(level_name: String) -> void:
	var path = "res://assets/Scenes/levels/%s.tscn" % level_name
	get_tree().change_scene_to_file(path)

func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/Scenes/cutscenes/intro-part-1.tscn")

func _on_level_3_pressed() -> void:
	load_level("Level3")

func _on_exit_pressed() -> void:
	get_tree().quit()
