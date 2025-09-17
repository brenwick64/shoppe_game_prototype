class_name SingleSoundComponent
extends SoundComponent

signal play_sound_finished()

@export var sound: AudioStream
@export var initial_delay_sec: float = 0.0

@onready var delay_timer: Timer = $DelayTimer

var _is_delay: bool = true

func _ready() -> void:
	super._ready()
	self.stream = sound
	if initial_delay_sec:
		delay_timer.wait_time = initial_delay_sec
	delay_timer.timeout.connect(_on_delay_timer_timeout)

## -- methods --
func play_sound() -> void:
	if _is_delay and initial_delay_sec:
		delay_timer.start()
		return
	_randomize_pitch()
	_randomize_volume()
	self.play()

func stop_sound() -> void:
	self.stop()

func _on_finished() -> void:
	play_sound_finished.emit()

func _on_delay_timer_timeout() -> void:
	_is_delay = false
	play_sound()
