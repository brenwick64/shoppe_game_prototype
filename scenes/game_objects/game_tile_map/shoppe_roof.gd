extends GenericLayer

@export var fade_duration_sec: float = 0.5 

var tween: Tween

func _on_area_2d_area_entered(_area: Area2D) -> void:
	_fade_to(0.0)

func _on_area_2d_area_exited(_area: Area2D) -> void:
	_fade_to(1.0)

func _fade_to(target_alpha: float) -> void:
	if tween and tween.is_running():
		tween.kill()  # Stop any running tween
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate:a", target_alpha, fade_duration_sec)
