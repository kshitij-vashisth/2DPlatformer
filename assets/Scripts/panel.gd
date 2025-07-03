extends Panel

@onready var panel_change_scene: Panel = $"../PanelChangeScene"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Anima.begin_single_shot(self) \
	.then(Anima.Node(self).anima_scale_y(1.0, 0.3).anima_from(0)) \
	.then(Anima.Node($VBoxContainer/RichTextLabel).anima_animation('typewrite', 0.03) ) \
	.then( Anima.Node($Button).anima_animation('tada', 0.5 ).anima_delay(-0.2) ) \
	.set_visibility_strategy(ANIMA.VISIBILITY.TRANSPARENT_ONLY) \
	.play_with_delay(0.5)


func _on_button_pressed() -> void:
	var anima = Anima.begin(self, 'fade_out')
	anima.with({ node = self, animation = 'fadeOut', duration = 0.3 })
	anima.with({ node = $VBoxContainer/RichTextLabel, animation = 'fadeOut', duration = 0.3 })
	anima.with({ node = $Button, animation = 'fadeOut', duration = 0.3 })
	anima.play()
