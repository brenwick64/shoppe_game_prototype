class_name GlobalLoopSoundComponent
extends AudioStreamPlayer

@export var audio_bus_name: String
@export var track: AudioStream
@export var play_cooldown_sec: float = 0.2  # prevents rapid spamming
@export var fade_time_sec: float = 0.5

@onready var play_cooldown: Timer = $PlayCooldown

var disabled: bool = false

var _is_fading_out: bool = false
var _current_tween: Tween

func _ready() -> void:
	play_cooldown.wait_time = play_cooldown_sec
	volume_db = Constants.MIN_DB # start muted
	if not track:
		push_error("GlobalLoopSoundComponent error: no track found.")
		disabled = true
		return
	stream = track

func _new_fade_tween(fade_to_db: float) -> Tween:
	# Kill any old tween
	if _current_tween and _current_tween.is_valid():
		_current_tween.kill()
	var new_tween: Tween = create_tween()
	new_tween.tween_property(self, "volume_db", fade_to_db, fade_time_sec)
	return new_tween

func fade_in() -> void:
	if disabled: return
	if play_cooldown.time_left > 0.0: return  # cooldown still invoked
	if playing and not _is_fading_out: return # already playing
	_is_fading_out = false
	play()
	
	_current_tween = _new_fade_tween(GlobalAudioManager.get_bus_db(audio_bus_name))
	play_cooldown.start(play_cooldown_sec)

func fade_out() -> void:
	if disabled: return
	if not playing: return
	_is_fading_out = true
	
	_current_tween = _new_fade_tween(Constants.MIN_DB)
	_current_tween.finished.connect(_on_fade_out_complete)

func _on_fade_out_complete() -> void:
	if _is_fading_out:  # only stop if we didn’t fade back in during transition
		stop()
		_is_fading_out = false
