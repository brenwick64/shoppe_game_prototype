class_name ItemToastUI
extends Control

@export var item_id: int
@export var item_count: int
@export var fadeout_start_time_sec: float = 2.0

@onready var name_label: Label = $Panel/NameLabel
@onready var count_label: Label = $Panel/CountLabel
@onready var despawn_timer: Timer = $DespawnTimer


var _current_count: int

## -- public methods --
func update_toast(item_id: int, count: int) -> void:
	_current_count += count
	count_label.text = str(_current_count)
	count_label.queue_redraw()
	despawn_timer.start()


## -- overrides --
func _ready() -> void:
	var item_data: RItemData = GlobalItemDb.get_item_by_id(item_id)
	if not item_data: return
	_current_count = item_count
	
	name_label.text = item_data.item_name
	count_label.text = str(_current_count)
	
func _physics_process(delta: float) -> void:
	var last_time_value: float = clamp(despawn_timer.time_left, 0, fadeout_start_time_sec)
	var modulate_sclar = last_time_value / fadeout_start_time_sec
	modulate = Color(1,1,1, modulate_sclar)


## -- signals --
func _on_despawn_timer_timeout() -> void:
	queue_free()
