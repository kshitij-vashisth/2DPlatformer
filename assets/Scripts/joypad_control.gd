extends Node2D

@export var max_speed := 800.0
@export var joy_deadzone := 0.2

const INTERNAL_DEVICE_ID := -2

# Device ID to use for joystick (-1 if none)
var joystick_device_id := -1

# Track mouse position and subpixel movement
var last_mouse_pos: Vector2
var movement_remainder: Vector2 = Vector2.ZERO

func ui_command():
	if Input.is_action_just_pressed("ui_accept"):
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = true
		event.position = get_viewport().get_mouse_position()
		event.device = -2  # INTERNAL_DEVICE_ID
		Input.parse_input_event(event)
	
	if Input.is_action_just_released("ui_accept"):
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = false
		event.position = get_viewport().get_mouse_position()
		event.device = -2
		Input.parse_input_event(event)

func _ready() -> void:
	# Initialize mouse position
	last_mouse_pos = get_global_mouse_position()

	# Get first connected joystick
	var joypads := Input.get_connected_joypads()
	if joypads.size() > 0:
		joystick_device_id = joypads[0]

	Input.connect("joy_connection_changed", self._on_joy_connection_changed)

func _on_joy_connection_changed(device_id: int, connected: bool) -> void:
	if connected and joystick_device_id == -1:
		joystick_device_id = device_id
	elif not connected and joystick_device_id == device_id:
		joystick_device_id = -1

func _process(delta: float) -> void:
	ui_command()
	if joystick_device_id == -1:
		return

	# Get right stick axis input
	var input_dir := Vector2(
		Input.get_joy_axis(joystick_device_id, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(joystick_device_id, JOY_AXIS_RIGHT_Y)
	)
	input_dir = apply_joy_deadzone(input_dir)

	var velocity := input_dir * max_speed
	var move := velocity * delta

	if move != Vector2.ZERO:
		move += movement_remainder
		var int_move := Vector2(int(move.x), int(move.y))
		movement_remainder = move - int_move

		var new_mouse_pos := last_mouse_pos + int_move
		var viewport_rect := get_viewport_rect()
		new_mouse_pos = new_mouse_pos.clamp(viewport_rect.position, viewport_rect.end - Vector2(1, 1))

		var motion_event := InputEventMouseMotion.new()
		motion_event.position = new_mouse_pos
		motion_event.relative = int_move
		motion_event.device = INTERNAL_DEVICE_ID
		Input.parse_input_event(motion_event)

		Input.warp_mouse(new_mouse_pos)
		last_mouse_pos = new_mouse_pos
	else:
		movement_remainder = Vector2.ZERO

func _input(event):
	if event is InputEventMouseMotion:
		last_mouse_pos = event.position

func apply_joy_deadzone(vec: Vector2) -> Vector2:
	if abs(vec.x) < joy_deadzone:
		vec.x = 0.0
	else:
		vec.x = (vec.x - sign(vec.x) * joy_deadzone) / (1.0 - joy_deadzone)

	if abs(vec.y) < joy_deadzone:
		vec.y = 0.0
	else:
		vec.y = (vec.y - sign(vec.y) * joy_deadzone) / (1.0 - joy_deadzone)

	return vec
