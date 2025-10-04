class_name Harvestable
extends StaticBody2D

@export_category("Configuration")
@export var pickup_item_id: int = -1
@export var harvestable_type: String

@export_category("Tuning Parameters")
@export var shake_time_range: Vector2 = Vector2(0.1, 0.25)
@export var swing_cooldown_sec: float = 1.0
@export var respawn_time_sec: float = 10.0

@export_category("Required Nodes")
@export var full_sprite: Sprite2D
@export var depleted_sprite: Sprite2D
@export var health_component: HealthComponent
@export var interactable: Interactable
@export var harvest_sound: SingleSoundComponent
@export var resource_icon: Panel
@export var harvest_cooldown: Timer
@export var respawn_timer: Timer

# --- State flags ---
var _is_focused: bool = false
var _is_harvest_cooldown: bool = false
var _is_depleted: bool = false

func _ready() -> void:
	interactable.interacted.connect(_on_interactable_interacted)
	interactable.focus_changed.connect(_on_interactable_focus_changed)
	health_component.health_depleted.connect(_on_health_component_health_depleted)
	harvest_cooldown.timeout.connect(_on_harvest_cooldown_timeout)
	respawn_timer.timeout.connect(_on_respawn_timer_timeout)


## -- public methods --
func harvest()-> void:
	if _is_depleted: return
	if _is_harvest_cooldown: return
	
	harvest_sound.play_sound()
	_is_harvest_cooldown = true
	harvest_cooldown.start()
	_shake_sprite()
	health_component.remove_health(1)


### -- helper functions --
func _show_full_sprite() -> void:
	full_sprite.visible = true
	depleted_sprite.visible = false
	
func _show_depleted_sprite() -> void:
	full_sprite.visible = false
	depleted_sprite.visible = true

func _update_resource_icon() -> void:
	resource_icon.visible = _is_focused and not _is_depleted

func _shake_sprite() -> void:
	full_sprite.material.set_shader_parameter("shake_intensity", 1)
	var shake_time: float = randf_range(shake_time_range.x, shake_time_range.y)
	await get_tree().create_timer(shake_time).timeout
	full_sprite.material.set_shader_parameter("shake_intensity", 0.0)

func _spawn_pickup() -> void:
	var spawn_positions: Array[Vector2] = GlobalTileManager.get_adjacent_ground_tiles_gp(
		global_position,
		"Grass",
		["navigatable", "unobstructed"]
	)
	if spawn_positions:
		var chosen_pos: Vector2 = spawn_positions.pick_random()
		GlobalItemSpawner.spawn_item_pickup(pickup_item_id, global_position, chosen_pos)
	else:
		GlobalItemSpawner.spawn_item_pickup(pickup_item_id, global_position, global_position)


## -- signal handlers --
func _on_harvest_cooldown_timeout() -> void:
	_is_harvest_cooldown = false

func _on_interactable_focus_changed(focused: bool) -> void:
	_is_focused = focused
	_update_resource_icon()

func _on_interactable_interacted() -> void:
	harvest()

func _on_health_component_health_depleted() -> void:
	_is_depleted = true
	interactable.disable_collision()
	respawn_timer.start(respawn_time_sec)
	
	_show_depleted_sprite()
	_update_resource_icon()
	_spawn_pickup()

func _on_respawn_timer_timeout() -> void:
	health_component.reset_health()
	_is_depleted = false
	interactable.enable_collision()
	
	_show_full_sprite()
	_update_resource_icon()
