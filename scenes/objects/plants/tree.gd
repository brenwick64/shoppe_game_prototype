extends StaticBody2D

@export var tree_shake_time_range: Vector2 = Vector2(0.5, 0.75)
@export var chop_cooldown_sec: float = 1.0
@export var respawn_time_sec: float = 10.0
@export var chops_to_fell: int = 3

@onready var tree_sprite: Sprite2D = $TreeSprite
@onready var stump_sprite: Sprite2D = $StumpSprite
@onready var chop_sound: SingleSoundComponent = $ChopSound
@onready var chop_cooldown: Timer = $ChopCooldown
@onready var respawn: Timer = $Respawn

var _is_chop_cooldown: bool = false
var _is_chopped_down: bool = false
var _current_chops: int = 0

func chop() -> void:
	if _is_chopped_down: return
	if _is_chop_cooldown: return
	chop_sound.play()
	_shake_tree()
	_is_chop_cooldown = true
	chop_cooldown.start()
	_current_chops += 1
	_check_tree()

## -- helper functions --
func _check_tree() -> void:
	if _current_chops >= chops_to_fell:
		_show_stump()
		_is_chopped_down = true
		respawn.start(respawn_time_sec)

func _show_tree() -> void:
	tree_sprite.visible = true
	stump_sprite.visible = false
	
func _show_stump() -> void:
	tree_sprite.visible = false
	stump_sprite.visible = true

func _shake_tree() -> void:
	tree_sprite.material.set_shader_parameter("shake_intensity", 1)
	var shake_time: float = randf_range(tree_shake_time_range.x, tree_shake_time_range.y)
	await get_tree().create_timer(shake_time).timeout
	tree_sprite.material.set_shader_parameter("shake_intensity", 0.0)

func _on_chop_cooldown_timeout() -> void:
	_is_chop_cooldown = false

func _on_interactable_interacted() -> void:
	chop()

func _on_respawn_timeout() -> void:
	_current_chops = 0
	_is_chopped_down = false
	_show_tree()
