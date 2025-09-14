extends AudioStreamPlayer

@export var fade_time_sec: float = 0.5

var day_loop: AudioStream = preload("res://audio/ambience/day/1_birds_outside.wav")
var night_loop: AudioStream = preload("res://audio/ambience/night/night_crickets_layer.wav")

const MIN_VOLUME_DB: float = -80.0

var max_volume_db: float = GlobalAudioManager.get_bus_db("ambience")

var _tween: Tween

func _ready() -> void:
	volume_db = max_volume_db
	stream = day_loop if DayAndNightManager.is_day() else night_loop
	DayAndNightManager.day_start.connect(_on_day_start)
	DayAndNightManager.night_start.connect(_on_night_start)
	play()

func _switch_tracks(new_stream: AudioStream) -> void:
	_fade_out(func():
		stop()
		stream = new_stream
		play()
		volume_db = MIN_VOLUME_DB
		_fade_in()
	)

func _fade_out(on_finished: Callable = Callable()) -> void:
	_fade_to(MIN_VOLUME_DB, fade_time_sec, on_finished)

func _fade_in() -> void:
	_fade_to(max_volume_db, fade_time_sec)
	
func _fade_to(db: float, duration: float, on_finished: Callable = Callable()) -> void:
	if _tween and _tween.is_running():
		_tween.kill()
		
	_tween = create_tween()
	_tween.tween_property(self, "volume_db", db, duration)
	
	if on_finished.is_valid():
		_tween.tween_callback(on_finished)

## -- signals --
func _on_day_start() -> void:
	if stream == night_loop:
		_switch_tracks(day_loop)
	
func _on_night_start() -> void:
	if stream == day_loop:
		_switch_tracks(night_loop)
