# UICountingLabel.gd
class_name UICountingLabel
extends Label

var current_value: int = 0
var _animated_value: float = 0.0
var _tween: Tween

@export var units_per_second: float = 800.0
@export var min_duration: float = 0.25
@export var max_duration: float = 0.80


## -- lifecycle --
func _ready() -> void:
	_animated_value = float(current_value)
	_update_text(current_value)


## -- public API --
func set_value_immediate(new_value: int) -> void:
	_kill_tween_if_running()
	current_value = new_value
	_animated_value = float(new_value)
	_update_text(new_value)


func animate_to(new_value: int) -> void:
	if new_value == current_value:
		return
	_kill_tween_if_running()

	var diff: int = abs(new_value - current_value)
	var duration: float = _compute_duration(diff)

	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_tween.tween_method(_on_animated_value, _animated_value, float(new_value), duration)
	_tween.finished.connect(func() -> void:
		_on_animated_value(float(new_value))
	)

	current_value = new_value


## -- helper functions --
func _on_animated_value(v: float) -> void:
	_animated_value = v
	_update_text(int(round(v)))


func _compute_duration(diff: int) -> float:
	if diff <= 0:
		return 0.0
	var d: float = float(diff) / max(units_per_second, 1.0)
	return clamp(d, min_duration, max_duration)


func _kill_tween_if_running() -> void:
	if _tween and _tween.is_running():
		_tween.kill()


func _update_text(value: int) -> void:
	text = Utils.int_to_comma_string(value)
