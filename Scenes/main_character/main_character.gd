extends CharacterBody2D


@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
var set_pos_bullet_spawn = bullet_spawn_point
var bullet_path = preload("res://Scenes/weapons/Bullet.tscn")
var last_direction: float = 1  # 1 = right, -1 = left
var has_gun: bool = true
@export var particle: PackedScene
@onready var sfx_jump: AudioStreamPlayer2D = $sfx_jump
@onready var sfx_coin_collect: AudioStreamPlayer2D = %SFXCoinCollect
@onready var sfx_shoot: AudioStreamPlayer2D = $sfx_shoot

@onready var gun: Sprite2D = $Gun

@onready var collision_shape_2d_normal: CollisionShape2D = $CollisionShape2DNormal
@onready var collision_shape_2d_crouch: CollisionShape2D = $CollisionShape2DCrouch

var last_facing_left: bool = false
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

func shoot(direction, bsp) -> void:
	var bullets = get_tree().get_nodes_in_group("bullets")
	if bullets.size() >= 2:
		return  # Already 2 bullets active, don't shoot
		
	sfx_shoot.play()	
	print("shooting")
	gun.show()
	#sprite_2d.animation = "shooting"
	var bullet = bullet_path.instantiate()
	get_parent().add_child(bullet)
	#get_tree().current_scene.add_child(bullet)
	bullet.dir = direction
	bullet.position = bsp.global_position
	print(bullet.global_position)
	await get_tree().create_timer(0.1).timeout
	gun.hide()
	

func jump() -> void:	
	jump_count += 1
	velocity.y = JUMP_VELOCITY
	sfx_jump.play()
	if jump_count==2:
		spawn_particle()

func side_jump(x) -> void:
	velocity.y = JUMP_VELOCITY/2
	velocity.x = 1.5*x
	
func spawn_particle() -> void:
	var particle_node = particle.instantiate()
	particle_node.global_position = global_position
	get_parent().add_child(particle_node)
	await get_tree().create_timer(0.3).timeout
	particle_node.queue_free()
	
func _ready()->void:
	gun.hide()

func _on_coin_collector_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "CollectibleNode":
		print("play")
		sfx_coin_collect.play()

func _physics_process(delta: float) -> void:
	var is_crouching = Input.is_action_pressed("down") and is_on_floor()
	$CollisionShape2DNormal.disabled = is_crouching
	$CollisionShape2DCrouch.disabled = not is_crouching
	# Add the gravity.
	if is_on_floor() and not(is_crouching):
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

	# Handle jump down through platform
	if Input.is_action_pressed("down") and Input.is_action_just_pressed("jump") and is_on_floor():
		position.y += 1  # nudge down through one-way
		return  # prevent normal jump this frame

	# Handle normal jump
	if Input.is_action_just_pressed("jump") and jump_count < 2:
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if not is_crouching:
		var direction := Input.get_axis("left", "right")
		
		
		# Flip gun sprite based on direction
		if direction != 0:
			last_direction = direction
			
		gun.flip_h = last_direction < 0
		# Move gun to the correct side
		if last_direction < 0:
			gun.position.x = -abs(gun.position.x)  # Move to left side
		else:
			gun.position.x = abs(gun.position.x)   # Move to right side
			
		# player direction	
		if direction:
			velocity.x = direction * SPEED
			if Input.is_action_pressed("sprint"):
				velocity.x *= 2 
			
		else:
			velocity.x = move_toward(velocity.x, 0, STEP_SPEED) # SPEED replaced with step speed
	else:
		velocity.x = move_toward(velocity.x, 0, STEP_SPEED)  # Gradually stop moving while crouched

	move_and_slide()

	if velocity.x > 1:
		last_facing_left = false
	elif velocity.x < -1:
		last_facing_left = true

	sprite_2d.flip_h = last_facing_left
	
	if Input.is_action_pressed("down") and is_on_floor():
		sprite_2d.animation = "crouch"
	
	if last_direction < 0:
		bullet_spawn_point.position.x = -abs(bullet_spawn_point.position.x)
	else: 	
		bullet_spawn_point.position.x = abs(bullet_spawn_point.position.x)
	
	if Input.is_action_just_pressed("fire") and has_gun == true:
		shoot(last_direction, bullet_spawn_point)
