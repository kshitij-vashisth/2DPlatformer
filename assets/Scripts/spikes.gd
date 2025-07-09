extends CharacterBody2D
@onready var spikes: CharacterBody2D = $"."
@onready var sfx_spike_release: AudioStreamPlayer2D = $sfx_spike_release
@onready var ui: CanvasLayer = %UI
@export var delay_duration: float = 0.0
@export var time_switcher: float = 2.0
@export var spike_position_y: int = -24
var switch: bool = false
var delay_time: float
var time: float = 0.0

func _ready() -> void:
	delay_time = delay_duration


func _process(delta: float) -> void:
	if delay_time > 0:
		delay_time -= delta
	
	if delay_time <= 0:
		time += delta
		if time >= time_switcher:
			time = 0.0
			switch = !switch
			if switch:
				sfx_spike_release.play()
				spikes.position.y += spike_position_y
			if !switch:
				spikes.position.y -= spike_position_y


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.vertical_knock()
		ui.decrease_health(1)
