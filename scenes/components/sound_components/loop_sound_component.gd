class_name LoopSoundComponent
extends AudioStreamPlayer2D

@export var delay_between_tracks: float = 0.38
@export var pitch_variance_range: Vector2 = Vector2(1.0, 1.0)
@export var volume_variance_range: Vector2 = Vector2(1.0, 1.0)
@export var play_cooldown_sec: float = 0.1  # prevents rapid spamming

@onready var track1 = preload("res://audio/player_movement/01-step-grass-trimmed.wav")
@onready var track2 = preload("res://audio/player_movement/02-step-grass-02_trimmed.wav")

@onready var play_cooldown: Timer = $PlayCooldown
@onready var delay_timer: Timer = $DelayTimer

# initial variables
var base_pitch_scale: float
var base_volume_db: float
var tracks = []
# dynamic variables
var _current_index = 0
var _is_playing: bool = false
var _is_play_cd: bool = false

func _ready() -> void:
	# set initial variables
	tracks = [track1, track2]
	base_pitch_scale = pitch_scale
	base_volume_db = volume_db
	# connect timers
	play_cooldown.timeout.connect(_on_play_cooldown_timeout)
	delay_timer.timeout.connect(_on_delay_timer_timeout)
	# connect finished signal
	finished.connect(_on_finished)

func play_loop() -> void:
	if _is_playing or _is_play_cd: return
	_is_playing = true
	_is_play_cd = true
	_play_current_track()
	play_cooldown.start()

func stop_loop() -> void:
	if not _is_playing: return
	_is_playing = false
	stop()
	_current_index = 0
	delay_timer.stop()

func _randomize_pitch() -> void:
	if pitch_variance_range.x <= 0 or pitch_variance_range.y <= 0: return
	pitch_scale = randf_range(
		base_pitch_scale * pitch_variance_range.x,
		base_pitch_scale * pitch_variance_range.y
	)

func _randomize_volume() -> void:
	if volume_variance_range.x <= 0 or volume_variance_range.y <= 0: return
	volume_db = randf_range(
		base_volume_db * volume_variance_range.x,
		base_volume_db * volume_variance_range.y
	)

func _play_current_track() -> void:
	if not _is_playing: return
	stream = tracks[_current_index]
	_randomize_volume()
	_randomize_pitch()
	play()

func _on_finished() -> void:
	if not _is_playing: return
	if not delay_timer.is_stopped(): return  # already scheduled
	delay_timer.start(delay_between_tracks)

func _on_play_cooldown_timeout() -> void:
	_is_play_cd = false

func _on_delay_timer_timeout() -> void:
	if not _is_playing: return
	_current_index = (_current_index + 1) % tracks.size()
	_play_current_track()
