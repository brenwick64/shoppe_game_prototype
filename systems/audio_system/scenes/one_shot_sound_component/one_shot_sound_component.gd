class_name OneShotSoundComponent
extends BaseSoundComponent

signal sound_finished

@export var initial_delay_sec: float = 0.0

@onready var initial_delay_timer: Timer = $InitialDelayTimer

var _is_delay: bool = false


## -- overrides --
func _ready() -> void:
	super._ready()
	if audio_data:
		stream = audio_data.audio_stream
	initial_delay_timer.timeout.connect(_on_initial_delay_timer_timeout)


## -- public methods --
func play_sound() -> void:
	if not _is_delay and initial_delay_sec:
		_is_delay = true
		initial_delay_timer.wait_time = initial_delay_sec
		initial_delay_timer.start()
	else:
		_configure_and_play_stream(audio_data)

func load_audio_data(p_audio_data: RAudioStreamData) -> void:
	audio_data = p_audio_data
	stream = audio_data.audio_stream

func stop_sound() -> void:
	self.stop()


## -- helper functions --
func _configure_and_play_stream(p_audio_data: RAudioStreamData) -> void:
	_randomize_pitch(p_audio_data)
	_scale_volume(p_audio_data)
	self.play()


## -- signals --
func _on_finished() -> void:
	sound_finished.emit()

func _on_initial_delay_timer_timeout() -> void:
	_is_delay = false
	_configure_and_play_stream(audio_data)
