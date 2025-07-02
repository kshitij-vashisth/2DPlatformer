extends Area2D

@onready var ui: CanvasLayer = $"../../../UI"

func _on_body_entered(body: Node2D) -> void:
	if body.name== "Player":
		#set ammo and has_gun state
		GameManager.has_gun = true
		GameManager.gun_ammo = 5
		
		ui.gun_picked()
		queue_free()
		
