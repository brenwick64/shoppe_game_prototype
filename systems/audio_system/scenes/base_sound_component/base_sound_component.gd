class_name BaseSoundComponent
extends AudioStreamPlayer2D

@export_category("Configuration")
@export var audio_data: RAudioStreamData
@export_category("Debug")
@export var DEBUG_MAX_RANGE: bool = false

var base_pitch_scale: float
var base_volume_db: float


## -- overrides --
func _ready() -> void:
	base_pitch_scale = self.pitch_scale
	base_volume_db = self.volume_db


## -- helper functions --
func _randomize_pitch(audio_data: RAudioStreamData) -> void:
	if audio_data.pitch_range_percent.x <= 0 or audio_data.pitch_range_percent.y <= 0: return
	var random_pitch: float = randf_range(
		base_pitch_scale * audio_data.pitch_range_percent.x,
		base_pitch_scale * audio_data.pitch_range_percent.y
	)
	pitch_scale = random_pitch

func _scale_volume(audio_data: RAudioStreamData) -> void:
	volume_db = base_volume_db + audio_data.decibel_scalar
