class_name MovementSoundComponent
extends AudioStreamPlayer2D

@export var audio_tracks: Array[RAudioStreamData]
@export var delay_between_tracks: float = 0.38
@export var play_cooldown_sec: float = 0.2  # prevents rapid spamming

@onready var track_delay: Timer = $TrackDelay
@onready var play_cooldown: Timer = $PlayCooldown

var base_pitch_scale: float
var base_volume_db: float

# dynamic variables
var _current_index = 0
var _is_playing: bool = false
var _is_play_cd: bool = false

func _ready() -> void:
	base_volume_db = volume_db
	base_pitch_scale = pitch_scale
	if self.autoplay: play_loop()
	track_delay.timeout.connect(_on_track_delay_timeout)
	play_cooldown.timeout.connect(_on_play_cooldown_timeout)

## -- methods --
func play_loop() -> void:
	#if not tracks: return
	if not audio_tracks: return
	if _is_playing: return
	if _is_play_cd: return
	_load_next_track()
	_initialize_current_track()
	_play_current_track()
	_is_playing = true
	_is_play_cd = true
	play_cooldown.start(play_cooldown_sec)

func stop_loop() -> void:
	stop()
	_reset_vars()
	track_delay.stop()

func switch_tracks(new_tracks: Array[RAudioStreamData]) -> void:
	audio_tracks = new_tracks


## -- helper functions --
func _reset_vars() -> void:
	_current_index = 0
	_is_playing = false

func _load_next_track() -> void:
	_current_index = (_current_index + 1) % audio_tracks.size()
	stream = audio_tracks[_current_index].audio_stream

func _initialize_current_track() -> void:
	var current_audio_settings: RAudioStreamData = audio_tracks[_current_index]
	var volume_scalar: float = current_audio_settings.decibel_scalar
	var pitch_range: Vector2 = current_audio_settings.pitch_range_percent
	volume_db = base_volume_db + volume_scalar
	# guard clause against bug with audio player 2D
	if pitch_range.x <= 0 or pitch_range.y <= 0: return
	pitch_scale = randf_range(
		base_pitch_scale * pitch_range.x,
		base_pitch_scale * pitch_range.y
	)

func _play_current_track() -> void:
	play()

## -- signals --
func _on_finished() -> void:
	track_delay.start(delay_between_tracks)

func _on_track_delay_timeout() -> void:
	if not _is_playing: return
	_load_next_track()
	_initialize_current_track()
	_play_current_track()

func _on_play_cooldown_timeout() -> void:
	_is_play_cd = false
