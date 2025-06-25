extends Area2D

func _game_over() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu/game_over.tscn")



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		call_deferred("_reload_scene")
		
func _reload_scene() -> void:
	GameManager.lives -= 1
	
	if GameManager.lives == 0:
		_game_over()
	else:
		get_tree().reload_current_scene()
	
