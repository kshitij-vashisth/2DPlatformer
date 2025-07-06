extends Area2D
@onready var ui: CanvasLayer = %UI

func _game_over() -> void:
	get_tree().change_scene_to_file("res://assets/Scenes/menu/game_over.tscn")

func _live_gone_screen() -> void:
	get_tree().change_scene_to_file("res://assets/Scenes/levels/LevelTransitionScreen.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$"../SceneObjects/Player".set_physics_process(false)
		$"../SceneObjects/Player".set_process(false)
		$"../SceneObjects/Player".hide()
		ui.spawn_defeat()
		await get_tree().create_timer(1.2).timeout
		call_deferred("_reload_scene")
		
func _reload_scene() -> void:
	GameManager.lives -= 1
	
	if GameManager.lives == 0:
		_game_over()
	else:
		#get_tree().reload_current_scene()
		call_deferred("_live_gone_screen")
	
