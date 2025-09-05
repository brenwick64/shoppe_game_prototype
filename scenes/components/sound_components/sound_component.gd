class_name SoundComponent
extends Node2D

@export var DEBUG_MAX_RANGE: bool = true

## -- overrides --as
func _draw() -> void:
	if DEBUG_MAX_RANGE:
		_draw_debug_max_range()

func _process(_delta: float) -> void:
	queue_redraw()
	
## -- helper functions --
func _draw_debug_max_range() -> void:
	var radius = self.max_distance
	draw_circle(Vector2.ZERO, radius, Color(0, 0.5, 1, 0.3))
