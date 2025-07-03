extends AnimationPlayer
@onready var dave_falling_sfx: AudioStreamPlayer2D = $"../dave_falling_sfx"
@onready var button: Button = $"../CanvasLayer/FallingPanel2/Button"
@onready var dave: AnimatedSprite2D = $"../Dave"
@onready var warped_sfx: AudioStreamPlayer2D = $"../warped_sfx"
@export var target_level : PackedScene

func _ready() -> void:
	dave_falling_sfx.play()
	play("falling")
	await get_tree().create_timer(1.4).timeout
	pause()


func _on_button_pressed() -> void:
	var anima = Anima.begin($"../CanvasLayer/FallingPanel2", 'fade_out')
	anima.with({ node = $"../CanvasLayer/FallingPanel2", animation = 'fadeOut', duration = 0.3 })
	anima.with({ node = $"../CanvasLayer/FallingPanel2/VBoxContainer/RichTextLabel", animation = 'fadeOut', duration = 0.3 })
	anima.with({ node = $"../CanvasLayer/FallingPanel2/Button", animation = 'fadeOut', duration = 0.3 })
	anima.play()
	
	
	play("warp")
	await get_tree().create_timer(1.66).timeout
	dave_falling_sfx.stop()
	warped_sfx.play()
	dave.play("warped")
	await dave.animation_finished
	dave.hide()
	await get_tree().create_timer(1.3).timeout
	get_tree().change_scene_to_packed(target_level)
	
