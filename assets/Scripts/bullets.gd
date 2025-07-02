extends CharacterBody2D

var travelled_distance: float = 0.0
const RANGE: float = 500.0
const SPEED = 800.0  # Much more reasonable value than 8000
var dir: float = 1  # should be either 1 (right) or -1 (left)

func _ready() -> void:
	add_to_group("bullets")


func _delete_later() -> void:
	if travelled_distance > RANGE:
		queue_free()

func _physics_process(delta: float) -> void:
	velocity.x = SPEED * (dir/abs(dir))
	travelled_distance += SPEED * delta
	
	#print(velocity.x)
	move_and_slide()
	_delete_later()
	# Check for collision
	#if is_on_wall() or is_on_floor() or is_on_ceiling():
		#queue_free()

		
