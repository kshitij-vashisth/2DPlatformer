extends AnimationPlayer
@onready var dave: AnimatedSprite2D = $"../Dave"
@onready var dave_walk_sfx: AudioStreamPlayer2D = $"../dave_walk_sfx"
@onready var camera_2d: Camera2D = $"../Dave/Camera2D"
@export var target_level : PackedScene

func _change_scene()-> void:
	get_tree().change_scene_to_packed(target_level)

func camera_angle_change() -> void:
	camera_2d.position.x = -168.333
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	dave.play("default")
	dave_walk_sfx.play()
	play("intro")
	await get_tree().create_timer(5).timeout
	camera_angle_change()
	await get_tree().create_timer(5).timeout
	dave_walk_sfx.stop()
	dave.play("stopped")
	
func _on_button_pressed() -> void:
	$"../CanvasLayer/PanelChangeScene".show()
	Anima.begin_single_shot($"../CanvasLayer/PanelChangeScene") \
	.then(Anima.Node($"../CanvasLayer/PanelChangeScene").anima_scale_y(1.0, 0.3).anima_from(0)) \
	.then(Anima.Node($"../CanvasLayer/PanelChangeScene/VBoxContainer/OneDay").anima_animation('typewrite', 0.03) ) \
	.then( Anima.Node($"../CanvasLayer/PanelChangeScene/ChangeScene").anima_animation('tada', 0.5 ).anima_delay(-0.2) ) \
	.set_visibility_strategy(ANIMA.VISIBILITY.TRANSPARENT_ONLY) \
	.play_with_delay(0.5)
	
func _on_change_scene_pressed() -> void:
	var anima = Anima.begin($"../CanvasLayer/PanelChangeScene", 'fade_out')
	anima.with({ node = $"../CanvasLayer/PanelChangeScene", animation = 'fadeOut', duration = 0.3 })
	anima.with({ node = $"../CanvasLayer/PanelChangeScene/VBoxContainer/OneDay", animation = 'fadeOut', duration = 0.3 })
	anima.with({ node = $"../CanvasLayer/PanelChangeScene/ChangeScene", animation = 'fadeOut', duration = 0.3 })
	anima.play()
	
	play("walk")
	dave.play("default")
	dave_walk_sfx.play()
	await get_tree().create_timer(1).timeout
	dave_walk_sfx.stop()
	dave.play("stopped")
	call_deferred("_change_scene")
