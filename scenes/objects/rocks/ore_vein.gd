extends StaticBody2D

@export var shake_time_range: Vector2 = Vector2(0.1, 0.25)
@export var swing_cooldown_sec: float = 1.0
@export var respawn_time_sec: float = 10.0
@export var max_health: int = 3

@onready var full_sprite: Sprite2D = $FullSprite
@onready var depleted_sprite: Sprite2D = $DepletedSprite

@onready var mine_sound: SingleSoundComponent = $MineSound
@onready var resource_icon: Panel = $ResourceIcon
@onready var harvest_cooldown: Timer = $HarvestCooldown
@onready var respawn_timer: Timer = $RespawnTimer

var _is_focused: bool = false
var _is_harvest_cooldown: bool = false
var _is_depleted: bool = false
var _current_health: int = max_health

func harvest()-> void:
	if _is_depleted: return
	if _is_harvest_cooldown: return
	mine_sound.play()
	_is_harvest_cooldown = true
	harvest_cooldown.start()
	_current_health -= 1
	_check_health()
	_shake()

### -- helper functions --
func _check_health() -> void:
	if _current_health <= 0:
		_show_depleted()
		_is_depleted = true
		respawn_timer.start(respawn_time_sec)
		_update_resource_icon()

func _show_full() -> void:
	full_sprite.visible = true
	depleted_sprite.visible = false
	
func _show_depleted() -> void:
	full_sprite.visible = false
	depleted_sprite.visible = true

func _update_resource_icon() -> void:
	if _is_focused and not _is_depleted:
		resource_icon.visible = true
	else:
		resource_icon.visible = false

func _shake() -> void:
	full_sprite.material.set_shader_parameter("shake_intensity", 1)
	var shake_time: float = randf_range(shake_time_range.x, shake_time_range.y)
	await get_tree().create_timer(shake_time).timeout
	full_sprite.material.set_shader_parameter("shake_intensity", 0.0)

func _on_harvest_cooldown_timeout() -> void:
	_is_harvest_cooldown = false

func _on_interactable_focus_changed(is_focused: bool) -> void:
	_is_focused = is_focused
	_update_resource_icon()

func _on_interactable_interacted() -> void:
	harvest()

func _on_respawn_timer_timeout() -> void:
	_current_health = max_health
	_is_depleted = false
	_show_full()
	_update_resource_icon()
