extends CharacterBody2D
@onready var sfx_gunshot: AudioStreamPlayer2D = $sfx_gunshot

const SPEED = 2000.0  # Much more reasonable value than 8000
var dir: int = 1  # should be either 1 (right) or -1 (left)

func _ready() -> void:
	sfx_gunshot.play()
	add_to_group("bullets")
	_delete_later()


func _delete_later() -> void:
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	velocity = Vector2(SPEED * dir, 0)
	move_and_slide()
	
	# Check for collision
	#if is_on_wall() or is_on_floor() or is_on_ceiling():
		#queue_free()

		
