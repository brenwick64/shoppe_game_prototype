class_name MovementSoundComponent
extends SoundComponent

@export var tracks: Array[AudioStream]
@export var delay_between_tracks: float = 0.38
@export var play_cooldown_sec: float = 0.2  # prevents rapid spamming

@onready var track_delay: Timer = $TrackDelay
@onready var play_cooldown: Timer = $PlayCooldown

# dynamic variables
var _current_index = 0
var _is_playing: bool = false
var _is_play_cd: bool = false

func _ready() -> void:
	super._ready()
	if self.autoplay: play_loop()
	track_delay.timeout.connect(_on_track_delay_timeout)
	play_cooldown.timeout.connect(_on_play_cooldown_timeout)

## -- methods --
func play_loop() -> void:
	if not tracks: return
	if _is_playing: return
	if _is_play_cd: return
	_load_next_track()
	_play_current_track()
	_is_playing = true
	_is_play_cd = true
	play_cooldown.start(play_cooldown_sec)

func stop_loop() -> void:
	stop()
	_reset_vars()
	track_delay.stop()

func switch_tracks(new_tracks: Array[AudioStream]) -> void:
	tracks = new_tracks

## -- helper functions --
func _reset_vars() -> void:
	_current_index = 0
	_is_playing = false

func _load_next_track() -> void:
	_current_index = (_current_index + 1) % tracks.size()
	stream = tracks[_current_index]

func _play_current_track() -> void:
	_randomize_volume()
	_randomize_pitch()
	play()

## -- signals --
func _on_finished() -> void:
	track_delay.start(delay_between_tracks)

func _on_track_delay_timeout() -> void:
	if not _is_playing: return
	_load_next_track()
	_play_current_track()

func _on_play_cooldown_timeout() -> void:
	_is_play_cd = false
