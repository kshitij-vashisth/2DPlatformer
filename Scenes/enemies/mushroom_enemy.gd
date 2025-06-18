extends RigidBody2D

@onready var sfx_hurt: AudioStreamPlayer2D = $sfx_hurt

@onready var ui: CanvasLayer = %UI
@export var move_speed: float = 300.0
var direction := -1  # Start moving left
@onready var sfx_stomp: AudioStreamPlayer2D = $sfx_stomp

@onready var ground_check: RayCast2D = $GroundCheck
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
# Apply horizontal motion manually
	linear_velocity.x = direction * move_speed

	# Let gravity handle vertical motion

	# If there's no ground ahead, turn around
	if not ground_check.is_colliding():
		direction *= -1
		sprite.scale.x *= -1
		ground_check.position.x *= -1




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullets"):
		print("hit")
		queue_free()
		
	#var y_delta: float
	if (body.name == "CharacterBody2D"):
		var y_delta: float = position.y - body.position.y
		var x_delta: float = body.position.x - position.x
		
		#print(y_delta)
		if y_delta < 50:
			#print("player health decrease")
			sfx_hurt.play()
			ui.decrease_health()
			if x_delta > 0:
				body.side_jump(800)
			else:
				body.side_jump(-800)
		elif y_delta > 50:
			#print("enemy damaged")
			body.spawn_particle()
			body.bounce_jump()
			hide()
			queue_free()
