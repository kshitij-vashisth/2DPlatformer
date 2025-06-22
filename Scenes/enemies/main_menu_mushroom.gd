extends CharacterBody2D
var dead: bool = false
var turns = 0
var SPEED = 300.0
var direction = -1
var health = 1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ground_check: RayCast2D = $GroundCheck

func add_gravity(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

func move_enemy()->void:
	velocity.x = SPEED * direction
	animated_sprite_2d.animation = "run"
	
func reverse_direction()->void:
	if is_on_wall():
		direction = -direction

func death()-> void:
	if turns > 9:
		await get_tree().create_timer(0.4).timeout
		dead = true
		SPEED = 0
		animated_sprite_2d.animation = "death"
		
func platform_edge()->void:
	death()
	if not ground_check.is_colliding():
		direction = -direction
		ground_check.position.x *= -1
		animated_sprite_2d.scale.x *= -1
		turns +=1
		print(turns)

func _physics_process(delta: float) -> void:
	if dead:
		return
	add_gravity(delta)
	move_enemy()
	move_and_slide()
	reverse_direction()
	platform_edge()
