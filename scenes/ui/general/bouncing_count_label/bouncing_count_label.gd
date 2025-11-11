class_name UiBouncingCountLabel
extends Label

@export var bounce_size_px: int = 8
@export var bounce_up_time: float = 0.10
@export var bounce_down_time: float = 0.20

var _tween: Tween
var _base_font_size: int


func _ready() -> void:
	# Cache the base size and create an explicit override so the tweened property exists.
	_base_font_size = get_theme_font_size("font_size")
	add_theme_font_size_override("font_size", _base_font_size)


func update_text(new_text: String) -> void:
	text = new_text

	# Refresh base (in case theme changed) and ensure override exists.
	_base_font_size = get_theme_font_size("font_size")
	add_theme_font_size_override("font_size", _base_font_size)

	if _tween and _tween.is_running():
		_tween.kill()

	var bigger_font_size: int = _base_font_size + bounce_size_px
	_tween = create_tween()

	# Up: pop
	_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "theme_override_font_sizes/font_size", bigger_font_size, bounce_up_time)

	# Down: settle
	_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "theme_override_font_sizes/font_size", _base_font_size, bounce_down_time)
