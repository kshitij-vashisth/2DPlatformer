extends Area2D

@export var target_level : PackedScene

func _ready() -> void:
	add_to_group("trophies")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.level_index += 1
		#await get_tree().create_timer(1).timeout
		call_deferred("_change_scene")

func _change_scene() -> void:
	get_tree().change_scene_to_packed(target_level)
