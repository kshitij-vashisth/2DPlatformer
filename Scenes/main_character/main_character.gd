extends CharacterBody2D

@export var particle: PackedScene
@onready var sfx_jump: AudioStreamPlayer2D = $sfx_jump

var bounced_this_frame: bool = false
const SPEED: float = 400.0
const JUMP_VELOCITY: float = -1000.0
const STEP_SPEED:float = 12.0
var jump_count: int = 0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func bounce_jump() -> void:
	bounced_this_frame = true          # remember we bounced
	#jump_count -= 1
	jump()         # launch upward

func jump() -> void:	
	jump_count += 1
	velocity.y = JUMP_VELOCITY
	sfx_jump.play()
	if jump_count==2:
		spawn_particle()

func side_jump(x) -> void:
	velocity.y = JUMP_VELOCITY/2
	velocity.x = 2*x
	
func spawn_particle() -> void:
	var particle_node = particle.instantiate()
	particle_node.global_position = global_position
	get_parent().add_child(particle_node)
	await get_tree().create_timer(0.3).timeout
	particle_node.queue_free()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if is_on_floor():
		jump_count = 0
		# running
		if (velocity.x > 1 || velocity.x < -1):
			sprite_2d.animation = "running"
		else:
			sprite_2d.animation = "default"
	
	else:
		velocity += get_gravity() * delta
		if jump_count == 1:
			sprite_2d.animation = "jumping"
		elif jump_count == 2:
			sprite_2d.animation = "double jumping"
	# If we bounced off an enemy, allow 1 more jump
	if bounced_this_frame:
		jump_count = 1
		bounced_this_frame = false

	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_count < 2:
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, STEP_SPEED) # SPEED replaced with step speed

	move_and_slide()

	var isLeft:bool = velocity.x < 0
	sprite_2d.flip_h = isLeft
