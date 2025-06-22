extends Node
@onready var pause_panel: Panel = %PausePanel

var pause_status: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var _v1 = delta
	var esc_pressed = Input.is_action_just_pressed("pause")
	if esc_pressed:
		pause_status = !pause_status
		get_tree().paused = pause_status
		if get_tree().paused == true:
			pause_panel.show()
		elif get_tree().paused == false:
			pause_panel.hide()


func _on_resume_button_pressed() -> void:
	pause_panel.hide()
	pause_status = false
	get_tree().paused = pause_status

func _on_main_menu_button_pressed() -> void:
	pause_status = false
	get_tree().paused = pause_status
	GameManager.points = 0
	GameManager.lives = 3
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")
