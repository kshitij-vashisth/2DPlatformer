extends Node2D
@export var rest_length: float = 2.0
@export var stiffness: float = 15.0
@export var damping: float = 2.0
@onready var player := get_parent()
@onready var rope: Line2D = $Line2D
@onready var ray: RayCast2D = $RayCast2D
var launched: bool = false
var target: Vector2
@onready var sfx_tongue_launch: AudioStreamPlayer2D = $sfx_tongue_launch

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ray.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("grapple_shoot"):
		launch()
	if Input.is_action_just_released("grapple_shoot") or player.is_jumping==true:
		retract()
		player.is_jumping = false
	if launched:
		handle_grapple(delta)
		
func launch() -> void:
	if ray.is_colliding():
		launched = true
		target = ray.get_collision_point()
		rope.show()
		sfx_tongue_launch.play()
		

func retract() -> void:
	launched = false
	rope.hide()
	
func handle_grapple(delta:float) -> void:
	var target_direction = player.global_position.direction_to(target)
	var target_distance = player.global_position.distance_to(target)
	
	var displacement = target_distance - rest_length
	
	var force: Vector2 = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude = stiffness * displacement
		var spring_force = target_direction * spring_force_magnitude
		
		var vel_dot = player.velocity.dot(target_direction)
		var damping_force = -damping * vel_dot * target_direction
		
		force = spring_force + damping_force
	
	player.velocity += force * delta
	update_rope()

func update_rope() -> void:
	rope.set_point_position(1, to_local(target))
	
	#if rope.get_point_count() < 2:
		#rope.add_point(Vector2.ZERO) # Start (player)
		#rope.add_point(Vector2.ZERO) # End (target)
	#rope.set_point_position(0, rope.to_local(player.global_position))
	#rope.set_point_position(1, rope.to_local(target))
