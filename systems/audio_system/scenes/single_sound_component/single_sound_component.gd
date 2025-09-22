class_name SingleSoundComponent
extends SoundComponent

signal play_sound_finished()

@export var sound: AudioStream
@export var initial_delay_sec: float = 0.0

@onready var delay_timer: Timer = $DelayTimer

var current_stream: AudioStream

var _is_delay: bool = true

func _ready() -> void:
	super._ready()
	self.stream = sound
	delay_timer.timeout.connect(_on_delay_timer_timeout)


## -- methods --
func play_sound() -> void:
	if _is_delay and initial_delay_sec:
		delay_timer.wait_time = initial_delay_sec
		delay_timer.start()
	else:
		_play_stream()

func play_custom_sound(audio_stream: AudioStream) -> void:
	stream = audio_stream
	if _is_delay and initial_delay_sec:
		delay_timer.wait_time = initial_delay_sec
		delay_timer.start()
	else:
		_play_stream()

func stop_sound() -> void:
	self.stop()

## -- helper functions --
func _play_stream() -> void:
	_randomize_pitch()
	_randomize_volume()
	self.play()

## -- signals --
func _on_finished() -> void:
	play_sound_finished.emit()

func _on_delay_timer_timeout() -> void:
	_is_delay = false
	_play_stream()
