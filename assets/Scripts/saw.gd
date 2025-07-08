extends CharacterBody2D


@onready var ui: CanvasLayer = %UI
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction := 1


var time: float = 0

func _physics_process(delta: float) -> void:
	
	velocity.x = direction * SPEED


	move_and_slide()
	
	time += delta
	if time >= 1.45:
		direction *= -1
		animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
		time = 0.0


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("player entered saw")
		ui.decrease_health(3)
