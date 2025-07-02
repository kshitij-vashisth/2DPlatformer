extends Area2D

@export var tutorial_text: Panel

var text_visible: bool = false
var player_inside: bool = false

func _process(delta: float) -> void:
	var _v = delta
	if player_inside and Input.is_action_just_pressed("interact"):
		text_visible = !text_visible
		tutorial_text.visible = text_visible
	
	if not text_visible:
		tutorial_text.hide()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_inside = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_inside = false
		text_visible = false
		tutorial_text.hide()
