extends Area2D
@onready var ui: CanvasLayer = %UI

enum State { UNBUMPED, BUMPED }
var state: int = State.UNBUMPED
var original_position: Vector2

func _ready() -> void:
	original_position = position

# Signal handler for body_entered	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and state == State.UNBUMPED:
		bump_block()

#logic for bumoing the block
func bump_block() -> void:
	state = State.BUMPED
	$AnimatedSprite2D.hide()
	$Sprite2D.frame = 1 #indicates that used
	ui.spawn_gun(self.global_position + Vector2(0, -60))
	bump_upwards()
	await get_tree().create_timer(0.2).timeout
	return_to_original_position()
	
func bump_upwards() -> void:
	position.y -= 20
	
func return_to_original_position() -> void:
	position =  original_position
