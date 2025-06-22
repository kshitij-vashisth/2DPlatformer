extends Node


func load_level(level_name: String) -> void:
	var path = "res://Scenes/levels/%s.tscn" % level_name
	get_tree().change_scene_to_file(path)

func _on_level_1_pressed() -> void:
	load_level("Level1")

func _on_level_3_pressed() -> void:
	load_level("Level3")



func _on_exit_pressed() -> void:
	if is_inside_tree():
		get_tree().quit()
