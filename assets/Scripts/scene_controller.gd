extends AnimationPlayer
@onready var player: AnimatedSprite2D = $"../Player"
@export var warp_in_effect: PackedScene
@onready var sfx_walk: AudioStreamPlayer2D = $"../sfx_walk"
@onready var lightning: AnimatedSprite2D = $"../Lightning"
@onready var sfx_thunder: AudioStreamPlayer2D = $"../Lightning/sfx_thunder"

func lightning_bolt() -> void:
	sfx_thunder.play()
	lightning.show()
	lightning.play("default")
	await lightning.animation_finished
	lightning.play("default")
	await lightning.animation_finished
	lightning.play("default")
	await lightning.animation_finished
	lightning.play("default")
	await lightning.animation_finished
	lightning.play("default")
	await lightning.animation_finished
	lightning.play("default")
	await lightning.animation_finished
	lightning.play("default")
	await lightning.animation_finished
	lightning.play("default")
	await lightning.animation_finished
	lightning.hide()

	
	
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
