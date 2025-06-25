extends Area2D

@onready var ui: CanvasLayer = %UI

func _on_body_entered(body: Node2D) -> void:
	if body.name== "Player":
		#set ammo and has_gun state
		GameManager.has_tome = true
		GameManager.tome_spells = 2
		
		ui.tome_picked()
		queue_free()
