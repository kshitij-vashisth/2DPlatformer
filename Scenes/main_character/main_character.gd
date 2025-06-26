extends CharacterBody2D

#Inventory=============================================
var has_gun: bool = GameManager.has_gun
var has_sword: bool = GameManager.has_sword
var has_tome: bool = GameManager.has_tome
var gun_ammo: int = GameManager.gun_ammo
var sword_strikes: int = GameManager.sword_strikes
var tome_spells: int = GameManager.tome_spells
var inventory = [gun_ammo, sword_strikes, tome_spells]
var current_weapon_index: int = GameManager.current_weapon_index  # 0 = gun, 1 = sword, 2 = tome
#========================================================

#SFXloader================================================
@onready var sfx_sword: AudioStreamPlayer2D = $sfx_sword
@onready var sfx_destro: AudioStreamPlayer2D = $sfx_destro
@onready var sfx_rect_hide: AudioStreamPlayer2D = $sfx_rect_hide
@onready var sfx_rect_show: AudioStreamPlayer2D = $sfx_rect_show
@onready var sfx_spell_read: AudioStreamPlayer2D = $sfx_spell_read
@onready var sfx_powerup: AudioStreamPlayer2D = $sfx_powerup
@onready var sfx_dash: AudioStreamPlayer2D = $sfx_dash
@onready var sfx_jump: AudioStreamPlayer2D = $sfx_jump
@onready var sfx_coin_collect: AudioStreamPlayer2D = %SFXCoinCollect
@onready var sfx_shoot: AudioStreamPlayer2D = $sfx_shoot
#=========================================================

#WhiteFlashRect=================================================
@onready var white_flash_rect: ColorRect = $"../../UI/WhiteFlashRect"
#===============================================================

#Booleans=======================================================
var tome_using: bool = false
var sword_striking: bool = false
var is_dashing: bool = false
var is_sliding: bool = false
var damaged: bool = false
var last_facing_left: bool = false
var bounced_this_frame: bool = false
var is_jumping: bool = false
var attack_animation_playing: bool = false
#===============================================================

#PhysicsVariables===============================================
const DASH_SPEED: float = 18200.0
const SPEED: float = 400.0
const JUMP_VELOCITY: float = -1000.0
const WALL_PUSHBACK: float = SPEED*2
const STEP_SPEED:float = 12.0
var jump_count: int = 0
var dash_duration: float = 0.8  # seconds
var dash_timer: float = 0.0
#===============================================================

#Colliders======================================================
@onready var collision_shape_2d_normal: CollisionShape2D = $CollisionShape2DNormal
@onready var collision_shape_2d_crouch: CollisionShape2D = $CollisionShape2DCrouch
@onready var sword_cut: CollisionShape2D = $SwordCollider/SwordCut
#========$TomeCollider/TomeShield=======================================================


@onready var ui: CanvasLayer = %UI
var check_lives:int = 0




@onready var ground_checker: RayCast2D = $GroundChecker
@onready var ground_checker_2: RayCast2D = $GroundChecker2

@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
var set_pos_bullet_spawn = bullet_spawn_point
var bullet_path = preload("res://Scenes/weapons/Bullet.tscn")
var last_direction: float = 1  # 1 = right, -1 = left

@export var particle: PackedScene
@export var dash_smoke: PackedScene
@export var spawn_dust: PackedScene


@onready var gun: Sprite2D = $Gun





@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _ready()->void:
	check_lives = GameManager.lives
	gun.hide()
	sprite_2d.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
func _on_animation_finished():
	# Only reset if it was an attack animation
	if sprite_2d.animation in ["sword_slash", "tome_attack"]:
		attack_animation_playing = false
		if sword_striking:
			sword_striking = false
		if tome_using:
			tome_using = false
		


func inventory_switcher() -> void:
	var previous_index := current_weapon_index

	var left := Input.is_action_just_pressed("inventory_left")
	var right := Input.is_action_just_pressed("inventory_right")

	if left:
		current_weapon_index = (current_weapon_index - 1 + 3) % 3
	elif right:
		current_weapon_index = (current_weapon_index + 1) % 3

	# Loop until we land on a weapon we actually have
	var loop_limit := 3
	while loop_limit > 0:
		if (current_weapon_index == 0 and has_gun) or \
		   (current_weapon_index == 1 and has_sword) or \
		   (current_weapon_index == 2 and has_tome):
			break  # Found valid weapon
		current_weapon_index = (current_weapon_index + (1 if right else -1) + 3) % 3
		loop_limit -= 1

	if current_weapon_index != previous_index:
		match current_weapon_index:
			0:
				print("Switched to Gun")
			1:
				print("Switched to Sword")
			2:
				print("Switched to Tome")
	
	GameManager.current_weapon_index = current_weapon_index



func bounce_jump() -> void:
	bounced_this_frame = true          # remember we bounced
	#jump_count -= 1
	sfx_jump.play()
	velocity.y = JUMP_VELOCITY

func ammo_checker() -> void:
	#GunAmmo=================================
	if GameManager.gun_ammo != gun_ammo:
		gun_ammo = GameManager.gun_ammo
	
	if GameManager.has_gun != has_gun:
		has_gun = GameManager.has_gun    
	
	if gun_ammo == 0:
		ui.gun_inactive()
		GameManager.has_gun = 0
	#==========================================

	#SwordStrikes=================================
	if GameManager.sword_strikes != sword_strikes:
		sword_strikes = GameManager.sword_strikes
	
	if GameManager.has_sword != has_sword:
		has_sword = GameManager.has_sword    
	
	if sword_strikes == 0:
		ui.sword_inactive()
		GameManager.has_sword = 0
	#===============================================
	
	#TomeUses=================================
	if GameManager.tome_spells != tome_spells:
		tome_spells = GameManager.tome_spells
	
	if GameManager.has_tome != has_tome:
		has_tome = GameManager.has_tome    
	
	if tome_spells == 0:
		ui.tome_inactive()
		GameManager.has_tome = 0
	#===============================================



func shoot(direction, bsp) -> void:
	var bullets = get_tree().get_nodes_in_group("bullets")
	if bullets.size() >= 2:
		return  # Already 2 bullets active, don't shoot
	if gun_ammo <= 0:
		return
	else:
		GameManager.gun_ammo -= 1
		sfx_shoot.play()    
		#print("shooting")
		gun.show()
		#sprite_2d.animation = "shooting"
		var bullet = bullet_path.instantiate()
		get_parent().add_child(bullet)
		#get_tree().current_scene.add_child(bullet)
		bullet.dir = direction
		bullet.position = bsp.global_position
		await get_tree().create_timer(0.1).timeout
		#print(bullet.global_position)
		gun.hide()
	
func damage_sprite()->void:
	if check_lives > GameManager.lives:
		damaged = true
		print("damaged")
		sprite_2d.play("damaged") 
		check_lives = GameManager.lives
		damaged = false
	#print(GameManager.lives)
	#print(check_lives)
	if check_lives < GameManager.lives:
		check_lives = GameManager.lives

func jump() -> void:
	if attack_animation_playing:
		return  # Don’t override animations while attacking
	if is_jumping == true:
		jump_count += 1
		velocity.y = JUMP_VELOCITY
		sfx_jump.play()
		if jump_count==2:
			spawn_particle()
		if is_on_floor():
			is_jumping = false
		
func dash():
	if attack_animation_playing:
		return  # Don’t override animations while attacking
	if Input.is_action_just_pressed("dash") and not is_dashing and last_direction != 0:
		is_dashing = true
		sfx_dash.play()
		dash_timer = dash_duration
		print("dashing")
		sprite_2d.play("dash")
		velocity.x = last_direction * DASH_SPEED
		if is_on_floor():
			spawn_dash_smoke(last_direction)
		else:
			spawn_particle()
			await get_tree().create_timer(0.05).timeout
			spawn_particle()
		

func side_jump(x) -> void:
	velocity.y = JUMP_VELOCITY/2
	velocity.x = 1.5*x
	
func spawn_dash_smoke(direction) -> void:
	var smoke_node = dash_smoke.instantiate()
	if direction < 0:
		smoke_node.scale.x *= -1
	smoke_node.global_position = global_position
	get_parent().add_child(smoke_node)
	await get_tree().create_timer(0.3).timeout
	smoke_node.queue_free()
	
func spawn_particle() -> void:
	var particle_node = particle.instantiate()
	particle_node.global_position = global_position
	get_parent().add_child(particle_node)
	await get_tree().create_timer(0.3).timeout
	particle_node.queue_free()
	
func spawn_dirt() -> void:
	var dust_node = spawn_dust.instantiate()

	var offset := Vector2.ZERO

	if is_on_wall():
		var wall_normal = get_wall_normal()
		offset.x = wall_normal.x * -33  # same direction as wall (left = -5, right = +5)

	dust_node.global_position = global_position + offset
	get_parent().add_child(dust_node)
	await get_tree().create_timer(0.3).timeout
	dust_node.queue_free()

func _on_coin_collector_area_entered(area: Area2D) -> void:
	if area.name == "EnemyArea":
		#print("Enemy Detected")
		var y_delta: float = area.position.y - position.y
		var x_delta: float = position.x - area.position.x 
		print(y_delta)
		
	if area.get_parent().name == "CollectibleNode":
		#print("play")
		sfx_coin_collect.play()    
			
	if area.get_parent().name == "PowerUps":
		#print("play")
		sfx_powerup.play()    
	
func wall_jump() -> void:
	if attack_animation_playing:
		return  # Don’t override animations while attacking
	jump_count = 1
	velocity.y = (JUMP_VELOCITY*2)/3
	sfx_jump.play()
	spawn_particle()
	# Push away from the wall
	if get_wall_normal().x > 0:  # wall on left
		velocity.x = WALL_PUSHBACK
		last_direction = 1
	elif get_wall_normal().x < 0:  # wall on right
		velocity.x = -WALL_PUSHBACK
		last_direction = -1

		

func handle_movement(is_crouching:bool,delta:float)->void:
	if attack_animation_playing:
		return  # Don’t override animations while attacking
	# Add the gravity.
	if is_on_floor() and not(is_crouching) and (damaged == false):
		jump_count = 0
		# running
		if (velocity.x > 1 || velocity.x < -1):
			sprite_2d.play("running")
		else:
			sprite_2d.play("default")
	
	else:
		if not is_on_wall():
			velocity += get_gravity() * delta
		if jump_count == 1 and (damaged == false) and not is_sliding:
			sprite_2d.play("jumping")
		elif jump_count == 2 and (damaged == false):
			sprite_2d.play("double jumping")
	# If we bounced off an enemy, allow 1 more jump
	if bounced_this_frame:
		jump_count = 1
		bounced_this_frame = false

func handle_wall_slide(GRAVITY: Vector2, delta: float) -> void:
	if is_on_wall() and not is_on_floor() and (velocity.y > 0 or velocity.y < 0):
		
		if !is_sliding:
			is_jumping = false
			spawn_dirt()
			is_sliding = true
		sprite_2d.play("wall_slide")
		velocity.y = 0
		var slide_speed = 4000
		if velocity.y < slide_speed:
			velocity.y += GRAVITY.y * delta * 0.8
	else:
		is_sliding = false



func handle_platform_pass()->void:
	# Handle jump down through platform
	if Input.is_action_pressed("down") and Input.is_action_just_pressed("jump") and is_on_floor() and (damaged == false):
		position.y += 1  # nudge down through one-way
		return  # prevent normal jump this frame

func handle_normal_jump()->void:
	# Handle normal jump
	if Input.is_action_just_pressed("jump") and jump_count < 2 and (damaged == false):
		is_jumping = true
		jump()

func is_on_ground() -> bool:
	if last_direction > 0:
		ground_checker.position.x *= -1
		ground_checker_2.position.x *= -1
	return (ground_checker.is_colliding() or ground_checker_2.is_colliding())

func _process(delta: float) -> void:
	#refresh_inventory()
	pass

func sword_slash():
	if attack_animation_playing: return
	sword_striking = true
	print("sword slashed")
	attack_animation_playing = true
	sfx_sword.play()
	sprite_2d.play("sword_slash") 
	GameManager.sword_strikes -= 1
	
	
func tome_use():
	if attack_animation_playing: return
	tome_using = true
	print("tome used")
	attack_animation_playing = true
	sfx_spell_read.play()
	sprite_2d.play("tome_attack")
	GameManager.tome_spells -= 1
	await sprite_2d.animation_finished
	
	 # Then trigger the flash + enemy kill
	await retro_triple_flash_then_kill()

func retro_triple_flash_then_kill():
	# Pause the game
	get_tree().paused = true

	# Allow UI to still run (very important!)
	#white_flash_rect.pause_mode = Node.PAUSE_MODE_PROCESS

	for i in 3:
		sfx_rect_show.play()
		white_flash_rect.show()
		await get_tree().create_timer(0.3).timeout
		sfx_rect_hide.play()
		white_flash_rect.hide()
		await get_tree().create_timer(0.3).timeout

	# Kill all enemies
	#kill_all_enemies()
	kill_all_enemies_in_camera()

	# Resume the game
	get_tree().paused = false
	sfx_destro.play()

func kill_all_enemies()->void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.is_visible_in_tree():
			enemy.queue_free()
			
func kill_all_enemies_in_camera()->void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		# Assuming your enemy script has the 'is_on_screen' property
		if enemy.has_method("queue_free_if_on_screen"): # Optional: defensive check
			enemy.queue_free_if_on_screen()


func _physics_process(delta: float) -> void:
	#DebugWallSlide=================================================================================
	if is_sliding:
		#print("Sliding on wall...")
		pass
	#===============================================================================================
	
	#CrouchColliderHandling=========================================================================
	var is_crouching = Input.is_action_pressed("down") and is_on_floor()
	$CollisionShape2DNormal.disabled = is_crouching
	$CollisionShape2DCrouch.disabled = not is_crouching
	#===============================================================================================
	
	#DebuggingDamage================================================================================
	if damaged:
		is_jumping = false
		is_sliding = false
		is_dashing = false
		is_crouching = false
		sword_striking = false
		tome_using = false
	#===============================================================================================
	
	#SwordSlashColliderHandling=====================================================================
	sword_cut.disabled = not sword_striking
	#===============================================================================================
	
	#TomeInvincibility==============================================================================
	if tome_using:
		sprite_2d.modulate.a = 0.3
	else:
		sprite_2d.modulate.a = 1.0
	#===============================================================================================
	
	#Inventory Handling==============================================================================
	inventory_switcher()
	if Input.is_action_just_pressed("fire") and not damaged:
		if current_weapon_index == 0 and has_gun:
			shoot(last_direction, bullet_spawn_point)
		elif current_weapon_index == 1 and has_sword and not is_sliding:
			sword_slash()
		elif current_weapon_index == 2 and has_tome and is_on_floor_only():
			tome_use()
	#=================================================================================================
	
	
	# Stronger condition to exit wall slide
	if is_on_floor_only() or velocity.y < 0 and not sword_striking:
		is_sliding = false
	
	
	
	damage_sprite()
	ammo_checker()
	handle_movement(is_crouching, delta)
	handle_platform_pass()
	
	
	
	
	
	if not is_on_floor() and is_on_wall():
		handle_wall_slide(get_gravity(), delta)
		if Input.is_action_just_pressed("jump"):
			wall_jump()
	else:
		if not is_crouching:
			handle_normal_jump()
	
	if not is_crouching and (damaged == false):
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
			# Start dash
			dash()
			
		else:
			velocity.x = move_toward(velocity.x, 0, STEP_SPEED) # SPEED replaced with step speed
	else:
		velocity.x = move_toward(velocity.x, 0, STEP_SPEED)  # Gradually stop moving while crouched
	
	if Input.is_action_pressed("down") and is_on_floor() and (damaged == false):
		sprite_2d.play("crouch")
	
	move_and_slide()
	
	# Handle dash timer
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0.0:
			is_dashing = false

	if velocity.x > 1:
		last_facing_left = false
	elif velocity.x < -1:
		last_facing_left = true

	sprite_2d.flip_h = last_facing_left
	
	if last_direction < 0:
		bullet_spawn_point.position.x = -abs(bullet_spawn_point.position.x)
	else:     
		bullet_spawn_point.position.x = abs(bullet_spawn_point.position.x)
	
	
	#if Input.is_action_just_pressed("fire") and has_gun == true and (damaged == false):
		#shoot(last_direction, bullet_spawn_point)



func _on_sword_collider_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.queue_free()
		
