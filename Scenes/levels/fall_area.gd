extends Area2D

func _game_over() -> void:
	GameManager.points = 0
	GameManager.lives = 3
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")



func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		call_deferred("_reload_scene")
		
func _reload_scene() -> void:
	GameManager.lives -= 1
	
	if GameManager.lives == 0:
		_game_over()
	else:
		get_tree().reload_current_scene()
	
