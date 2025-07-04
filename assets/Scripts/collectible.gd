extends Area2D
@export var cherry_points: int = 100
@onready var ui: CanvasLayer = %UI


func _on_body_entered(body: Node2D) -> void:
	if body.name== "Player":
		ui.add_points(cherry_points)
		ui.add_cherries()
		queue_free()
		
