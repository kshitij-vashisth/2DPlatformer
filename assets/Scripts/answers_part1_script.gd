extends AnimationPlayer
@onready var player: AnimatedSprite2D = $"../Player"
@export var warp_in_effect: PackedScene
@onready var sfx_walk: AudioStreamPlayer2D = $"../sfx_walk"
@onready var lightning: AnimatedSprite2D = $"../Lightning"
@onready var sfx_thunder: AudioStreamPlayer2D = $"../Lightning/sfx_thunder"
@onready var merchant: AnimatedSprite2D = $"../Merchant"
@onready var color_rect: ColorRect = $"../CanvasLayer/ColorRect"
@onready var sfx_rect_show: AudioStreamPlayer2D = $"../sfx_rect_show"
@onready var sfx_rect_hide: AudioStreamPlayer2D = $"../sfx_rect_hide"
@onready var final_text: RichTextLabel = $"../CanvasLayer/FinalText"
@onready var warp_zone: AnimatedSprite2D = $"../warp_zone"
@onready var sfx_warp_zone: AudioStreamPlayer2D = $"../sfx_warp_zone"
@onready var sfx_achieved: AudioStreamPlayer2D = $"../sfx_achieved"
@onready var sfx_merchant_speaks: AudioStreamPlayer2D = $"../sfx_merchant_speaks"
@onready var sfx_warp_out: AudioStreamPlayer2D = $"../sfx_warp_out"
@export var target_level : PackedScene

func _change_scene()-> void:
	get_tree().change_scene_to_packed(target_level)

func player_exit() -> void:
	player.play("walk")
	sfx_walk.play()
	play("walk_out")
	await get_tree().create_timer(1).timeout
	sfx_walk.stop()
	sfx_warp_out.play()
	player.play("warped")
	await player.animation_finished
	player.hide()
	call_deferred("_change_scene")

func warp_zone_entry()->void:
	warp_zone.show()
	var anima = Anima.begin(warp_zone, 'fade_in')
	anima.with({ node = warp_zone, animation = 'fadeIn', duration = 0.3 })
	anima.play()
	
func panel_appears(panel: Panel, panel_text: RichTextLabel, panel_button: Button) -> void:
	panel.show()
	Anima.begin_single_shot(panel) \
	.then(Anima.Node(panel).anima_scale_y(1.0, 0.3).anima_from(0)) \
	.then(Anima.Node(panel_text).anima_animation('typewrite', 0.03) ) \
	.then( Anima.Node(panel_button).anima_animation('tada', 0.5 ).anima_delay(-0.2) ) \
	.set_visibility_strategy(ANIMA.VISIBILITY.TRANSPARENT_ONLY) \
	.play_with_delay(0.5)

func final_disappears()-> void:
	var anima = Anima.begin(merchant, 'fade_out')
	anima.with({ node = merchant, animation = 'fadeOut', duration = 0.3 })
	anima.with({ node = final_text, animation = 'fadeOut', duration = 0.3 })
	anima.play()

func panel_disappears(panel: Panel, panel_text: RichTextLabel, panel_button: Button) -> void:
	var anima = Anima.begin(panel, 'fade_out')
	anima.with({ node = panel, animation = 'fadeOut', duration = 0.3 })
	anima.with({ node = panel_text, animation = 'fadeOut', duration = 0.3 })
	anima.with({ node = panel_button, animation = 'fadeOut', duration = 0.3 })
	anima.play()
	#panel.hide()


func lightning_bolt() -> void:
	sfx_thunder.play()
	lightning.show()
	for i in range(8):
		lightning.play("default")
		await lightning.animation_finished
	lightning.hide()

func final_text_animation() -> void:
	final_text.show()

func retro_flash()-> void:
	for i in range(3):
		color_rect.show()
		sfx_rect_show.play()
		await get_tree().create_timer(0.3).timeout
		color_rect.hide()
		sfx_rect_hide.play()
		await get_tree().create_timer(0.3).timeout

func merchant_interaction() -> void:
	for i in range(3):
		merchant.play("interact")
		await merchant.animation_finished
	
	merchant.play("default")

	
	
func _ready() -> void:
	lightning.hide()
	player.hide()
	
	# player spawns
	var particle_node = warp_in_effect.instantiate()
	particle_node.global_position = player.global_position
	get_parent().add_child.call_deferred(particle_node)
	await get_tree().create_timer(0.35).timeout
	particle_node.queue_free()
	
	
	#player walks to merchant
	player.show()
	sfx_walk.play()
	player.play("walk")
	play("walk")
	await get_tree().create_timer(9).timeout
	sfx_walk.stop()
	player.play("default")
	
	# lightning strikes
	lightning_bolt()
	
	await get_tree().create_timer(4).timeout
	# merchant scene
	merchant_interaction()
	await get_tree().create_timer(2.5).timeout
	panel_appears($"../CanvasLayer/Panel", $"../CanvasLayer/Panel/VBoxContainer/RichTextLabel", $"../CanvasLayer/Panel/Dialog1Button")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



	


func _on_dialog_1_button_pressed() -> void:
	panel_disappears($"../CanvasLayer/Panel", $"../CanvasLayer/Panel/VBoxContainer/RichTextLabel", $"../CanvasLayer/Panel/Dialog1Button")
	panel_appears($"../CanvasLayer/Panel2", $"../CanvasLayer/Panel2/VBoxContainer/RichTextLabel", $"../CanvasLayer/Panel2/Dialog2Button")
	
	await get_tree().create_timer(0.5).timeout
	sfx_merchant_speaks.play()
	merchant.play("speaking")
	await get_tree().create_timer(6).timeout
	merchant.play("default")
	sfx_merchant_speaks.stop()


func _on_dialog_2_button_pressed() -> void:
	panel_disappears($"../CanvasLayer/Panel2", $"../CanvasLayer/Panel2/VBoxContainer/RichTextLabel", $"../CanvasLayer/Panel2/Dialog2Button")
	merchant.play("chest_opens")
	await merchant.animation_finished
	$"../sfx_chant".play()
	for i in range(3):
		merchant.play("chest_open_speaking")
		await merchant.animation_finished
	lightning_bolt()
	merchant.play("default")
	await get_tree().create_timer(4).timeout
	retro_flash()
	await get_tree().create_timer(1).timeout
	sfx_achieved.play()
	await get_tree().create_timer(0.5).timeout
	final_text_animation()
	await get_tree().create_timer(5).timeout
	final_disappears()
	await get_tree().create_timer(1).timeout
	sfx_warp_zone.play()
	warp_zone_entry()
	await get_tree().create_timer(1).timeout
	print("bullet damge was: "+str(GameManager.bullet_damage))
	GameManager.bullet_damage += 1
	print("bullet damge is: "+str(GameManager.bullet_damage))
	player_exit()
