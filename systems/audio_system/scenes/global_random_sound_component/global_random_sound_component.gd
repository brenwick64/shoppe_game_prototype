class_name GlobalRandomSoundComponent
extends AudioStreamPlayer

@export var audio_bus_name: String
@export var tracks: Array[AudioStream]
@export var initial_delay_sec: float = 0.0
@export var track_variance_sec: Vector2 = Vector2(5.0, 5.0)
@export var play_cooldown_sec: float = 0.9  # prevents rapid spamming
@export var fade_time_sec: float = 0.5

@onready var initial_delay: Timer = $InitialDelay
@onready var random_cooldown: Timer = $RandomCooldown

var disabled: bool = false
var is_looping: bool = false

var _is_fading_out: bool = false
var _current_tween: Tween

func _ready() -> void:	
	volume_db = Constants.MIN_DB # start muted
	if tracks.size() == 0:
		push_error("GlobalRandomSoundComponent error: no tracks found.")
		disabled = true
		return

func _process(_delta: float) -> void:
	if not is_looping: return
	if initial_delay.time_left > 0.0: return
	if random_cooldown.time_left > 0.0: return
	_set_random_track()
	play()
	random_cooldown.start(randf_range(track_variance_sec.x, track_variance_sec.y))

## -- methods --
func fade_in() -> void:
	if disabled: return
	_is_fading_out = false
	_current_tween = _new_fade_tween(GlobalAudioManager.get_bus_db(audio_bus_name))
	
	is_looping = true
	if initial_delay_sec:
		initial_delay.start(initial_delay_sec)

func fade_out() -> void:
	if disabled: return
	is_looping = false
	
	_current_tween = _new_fade_tween(Constants.MIN_DB)
	_current_tween.finished.connect(_on_fade_out_complete)

## -- helper functions --
func _set_random_track() -> void:
	stream = tracks.pick_random()

func _new_fade_tween(fade_to_db: float) -> Tween:
	# Kill any old tween
	if _current_tween and _current_tween.is_valid():
		_current_tween.kill()
	var new_tween: Tween = create_tween()
	new_tween.tween_property(self, "volume_db", fade_to_db, fade_time_sec)
	return new_tween

## -- signals --
func _on_fade_out_complete() -> void:
	if _is_fading_out:  # only stop if we didn’t fade back in during transition
		stop()
		_is_fading_out = false
