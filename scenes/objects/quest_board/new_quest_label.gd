# FloatLabelTween.gd
class_name FloatLabelTween
extends Label

@export var amplitude: float = 2.5   # pixels
@export var duration: float = 1.0      # seconds per half-cycle

var _base: Vector2

func _ready() -> void:
	_base = position
	position = _base - Vector2(0, amplitude)  # start at top so loop is seamless

	var t: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_loops(-1)
	t.tween_property(self, "position", _base + Vector2(0, amplitude), duration)
	t.tween_property(self, "position", _base - Vector2(0, amplitude), duration)
