extends CanvasLayer  # or Control
@onready var powerup_holder: Node = $"../SceneObjects/PowerUps"
@onready var points_label: Label = %PointsLabel
@export var hearts: Array[Node]
@onready var sfx_powerup = $sfx_powerup
var current_weapon_index: int = GameManager.current_weapon_index

@export var gun_node: Array[Node]
@export var sword_node: Array[Node]
@export var tome_node: Array[Node]

@onready var gun_ammo: RichTextLabel = $Inventory/HBoxContainer/Gun/Gun_ammo
@onready var sword_strikes: RichTextLabel = $Inventory/HBoxContainer/Sword/sword_strikes
@onready var tome_uses: RichTextLabel = $Inventory/HBoxContainer/Tome/tome_uses

func _ready() -> void:
	update_ui()
	current_weapon_index= GameManager.current_weapon_index

#func _update_inventory_icons() -> void:
	#if GameManager.has_gun:
		#gun_texture()
	#else:
		#gun_inactive()
#
	#if GameManager.has_sword:
		#sword_picked()
	#else:
		#sword_inactive()
#
	#if GameManager.has_tome:
		#tome_picked()
	#else:
		#tome_inactive()

func _game_over() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu/game_over.tscn")

func decrease_health() -> void:
	GameManager.lives -= 1
	#print("Lives left:", GameManager.lives)
	update_hearts()
	if GameManager.lives == 0:
		call_deferred("_game_over")

func add_points() -> void:
	GameManager.points += 1
	update_points()

func update_points() -> void:
	if points_label:
		points_label.text = str(GameManager.points)

func update_hearts() -> void:
	for h in 3:
		if h < GameManager.lives:
			hearts[h].show()
		else:
			hearts[h].hide()

func gun_picked() -> void:
	sfx_powerup.play()
	gun_texture()

func gun_texture() -> void:
	var new_texture: Texture2D = preload("res://assets/game_elements/pistol_inventory.png")
	gun_ammo.show()
	for gun in gun_node:
		if gun is Sprite2D:
			gun.texture = new_texture
		elif gun is TextureRect:
			gun.texture = new_texture	

func gun_inactive() -> void:
	var new_texture: Texture2D = preload("res://assets/game_elements/Inventory_box.png")
	gun_ammo.hide()
	for gun in gun_node:
		if gun is Sprite2D:
			gun.texture = new_texture
		elif gun is TextureRect:
			gun.texture = new_texture

func sword_picked() -> void:
	var new_texture: Texture2D = preload("res://assets/game_elements/sword_inventory.png")
	sword_strikes.show()
	for sword in sword_node:
		if sword is Sprite2D:
			sword.texture = new_texture
		elif sword is TextureRect:
			sword.texture = new_texture

func sword_inactive() -> void:
	var new_texture: Texture2D = preload("res://assets/game_elements/Inventory_box.png")
	sword_strikes.hide()
	for sword in sword_node:
		if sword is Sprite2D:
			sword.texture = new_texture
		elif sword is TextureRect:
			sword.texture = new_texture
			
func tome_picked() -> void:
	var new_texture: Texture2D = preload("res://assets/game_elements/tome_inventory.png")
	tome_uses.show()
	for tome in tome_node:
		if tome is Sprite2D:
			tome.texture = new_texture
		elif tome is TextureRect:
			tome.texture = new_texture

func tome_inactive() -> void:
	var new_texture: Texture2D = preload("res://assets/game_elements/Inventory_box.png")
	tome_uses.hide()
	for tome in tome_node:
		if tome is Sprite2D:
			tome.texture = new_texture
		elif tome is TextureRect:
			tome.texture = new_texture

#SpawningMethods=======================================
func spawn_gun(pos) -> void:
	call_deferred("_deferred_spawn_gun", pos)
	
func _deferred_spawn_gun(pos) -> void:
	var GunScene = preload("res://Scenes/weapons/pistol_powerup.tscn")
	var gun = GunScene.instantiate()
	gun.global_position = pos
	powerup_holder.add_child(gun)
	#get_tree().current_scene.add_child(gun)
#======================================================

func update_ui() -> void:
	update_points()
	update_hearts()
	if GameManager.has_gun:
		gun_texture()
	if GameManager.has_sword:
		sword_picked()
	if GameManager.has_tome:
		tome_picked()
	
func update_weapon_border() -> void:
	# Reset all nodes' modulate to default
	for node in gun_node + sword_node + tome_node:
		if node is TextureRect or node is Sprite2D:
			node.self_modulate = Color(1, 1, 1)  # Normal

	# Determine which group to highlight, if player has the weapon
	var selected_group: Array[Node] = []

	match current_weapon_index:
		0:
			if GameManager.has_gun:
				selected_group = gun_node
		1:
			if GameManager.has_sword:
				selected_group = sword_node
		2:
			if GameManager.has_tome:
				selected_group = tome_node

	# Highlight only the valid selected group
	for node in selected_group:
		if node is TextureRect or node is Sprite2D:
			node.self_modulate = Color(1.5, 1.5, 1.5)  # Bright highlight


	
func _physics_process(delta: float) -> void:
	current_weapon_index= GameManager.current_weapon_index
	gun_ammo.text = str(GameManager.gun_ammo)
	sword_strikes.text=str(GameManager.sword_strikes)
	tome_uses.text=str(GameManager.tome_spells)
	update_weapon_border()
