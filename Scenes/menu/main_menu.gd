extends Node


func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/levels/Level1.tscn")

func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/levels/Level3.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
