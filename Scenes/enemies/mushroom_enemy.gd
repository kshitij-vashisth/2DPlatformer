extends CharacterBody2D

#OnScreenLogic==================================================================
var is_on_screen:bool = false
func _ready():
	add_to_group("enemies")
	var visibility_notifier = $VisibleOnScreenNotifier2D
	if visibility_notifier:
		visibility_notifier.screen_entered.connect(_on_VisibilityNotifier2D_screen_entered)
		visibility_notifier.screen_exited.connect(_on_VisibilityNotifier2D_screen_exited)

func _on_VisibilityNotifier2D_screen_entered():
	is_on_screen = true

func _on_VisibilityNotifier2D_screen_exited():
	is_on_screen = false

func queue_free_if_on_screen():
	if is_on_screen:
		queue_free()
#===============================================================================




@onready var sfx_hurt: AudioStreamPlayer2D = $sfx_hurt

@onready var ui: CanvasLayer = %UI
@export var move_speed: float = 300.0
var health: int = 1

var direction := -1  # Start moving left
@onready var sfx_stomp: AudioStreamPlayer2D = $sfx_stomp
@onready var wall_check: RayCast2D = $WallCheck
@onready var ground_check: RayCast2D = $GroundCheck
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D



func add_gravity(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

func move_enemy()->void:
	velocity.x = move_speed * direction
	sprite.animation = "run"
	
func reverse_direction()->void:
	if is_on_wall():
		direction = -direction
		ground_check.position.x *= -1
		sprite.scale.x *= -1
		
func platform_edge()->void:
	if not ground_check.is_colliding():
		direction = -direction
		wall_check.position.x *= -1
		ground_check.position.x *= -1
		sprite.scale.x *= -1

func wall_checker()->void:
	if wall_check.is_colliding():
		direction = -direction

func _physics_process(delta: float) -> void:
	add_gravity(delta)
	move_enemy()
	#wall_checker()
	platform_edge()
	move_and_slide()
	reverse_direction()
	




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullets"):
		print("hit")
		body.queue_free()
		queue_free()
		
	#var y_delta: float
	if (body.name == "Player"):
		var y_delta: float = position.y - body.position.y
		var x_delta: float = body.position.x - position.x
		#print(y_delta)
		
		
		#print(y_delta)
		if y_delta < 20 and body.tome_using == false:
			#print("player health decrease")
			sfx_hurt.play()
			ui.decrease_health()
			if x_delta > 0:
				body.side_jump(500)
			else:
				body.side_jump(-500)
		elif y_delta > 20:
			#print("enemy damaged")
			body.spawn_particle()
			body.bounce_jump()
			hide()
			queue_free()
