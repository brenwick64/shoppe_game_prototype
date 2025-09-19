class_name SoundComponent
extends AudioStreamPlayer2D

@export_category("Debug")
@export var DEBUG_MAX_RANGE: bool = false
@export_category("Configuration")
@export var pitch_variance_range: Vector2 = Vector2(1.0, 1.0)
@export var volume_variance_range: Vector2 = Vector2(0.0, 0.0)

var base_pitch_scale: float
var base_volume_db: float

func _ready() -> void:
	base_pitch_scale = self.pitch_scale
	base_volume_db = self.volume_db

## -- helper functions --
func _randomize_pitch() -> void:
	if pitch_variance_range.x <= 0 or pitch_variance_range.y <= 0: return
	self.pitch_scale = randf_range(
		base_pitch_scale * pitch_variance_range.x,
		base_pitch_scale * pitch_variance_range.y
	)

func _randomize_volume() -> void:
	# TODO: match to have a percent diff
	self.volume_db = randf_range(
		base_volume_db + volume_variance_range.x,
		base_volume_db + volume_variance_range.y
	)

## -- debug --
func _draw_debug_max_range() -> void:
	var radius = self.max_distance
	draw_circle(Vector2.ZERO, radius, Color(0, 0.5, 1, 0.1))

func _draw() -> void:
	if DEBUG_MAX_RANGE: _draw_debug_max_range()

func _process(_delta: float) -> void:
	queue_redraw()
