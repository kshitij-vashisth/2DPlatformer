extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction := -1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var time: float = 0

func _physics_process(delta: float) -> void:
	
	velocity.x = direction * SPEED


	move_and_slide()
	
	time += delta
	if time >= 3.0:
		direction *= -1
		animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
		time = 0.0
	
