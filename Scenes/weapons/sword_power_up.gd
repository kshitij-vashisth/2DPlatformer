extends Area2D

@onready var ui: CanvasLayer = %UI

func _on_body_entered(body: Node2D) -> void:
	if body.name== "Player":
		#set ammo and has_gun state
		GameManager.has_sword = true
		GameManager.sword_strikes = 3
		
		ui.sword_picked()
		queue_free()
