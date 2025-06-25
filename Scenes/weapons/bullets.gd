extends CharacterBody2D

const SPEED = 800.0  # Much more reasonable value than 8000
var dir: float = 1  # should be either 1 (right) or -1 (left)

func _ready() -> void:
	add_to_group("bullets")
	_delete_later()


func _delete_later() -> void:
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	var _v1 = delta
	velocity.x = SPEED * (dir/abs(dir))
	#print(velocity.x)
	move_and_slide()
	
	# Check for collision
	#if is_on_wall() or is_on_floor() or is_on_ceiling():
		#queue_free()

		
