extends Area2D
@export var warp_out: PackedScene
@export var target_level : PackedScene


func spawn_warp(player_position: Vector2) -> void:
	var warp_node = warp_out.instantiate()
	warp_node.global_position = player_position
	get_parent().add_child(warp_node)
	await get_tree().create_timer(0.3).timeout
	warp_node.queue_free()

func _ready() -> void:
	add_to_group("trophies")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.level_index += 1
		if GameManager.level_index == 3:
			GameManager.tutorial_completed = true
		GameManager.save_to_file()
		$sfx_warp_in.play()
		body.hide()
		spawn_warp(body.global_position)
		await get_tree().create_timer(0.3).timeout
		call_deferred("_change_scene")

func _change_scene() -> void:
	get_tree().change_scene_to_packed(target_level)
