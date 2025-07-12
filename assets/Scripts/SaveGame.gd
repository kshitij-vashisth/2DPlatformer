class_name SaveGame
extends Resource

const SAVE_GAME_PATH: String = "user://savegame.tres"

@export var points: int
@export var lives: int
@export var hearts: int
@export var cherries: int

@export var has_gun: bool
@export var has_sword: bool
@export var has_tome: bool
@export var first_load: bool
@export var tutorial_completed: bool

@export var gun_ammo: int
@export var sword_strikes: int
@export var tome_spells: int
@export var current_weapon_index: int

@export var bullet_damage: int
@export var sword_damage: int
@export var tome_damage: int

@export var player_dash_duration: float
@export var player_speed: float
@export var player_jump_height: float

@export var level_index: int
