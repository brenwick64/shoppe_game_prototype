class_name SingleSoundComponent
extends SoundComponent

signal play_sound_finished()

@export var sound: AudioStream

func _ready() -> void:
	super._ready()
	self.stream = sound

## -- methods --
func play_sound() -> void:
	_randomize_pitch()
	_randomize_volume()
	self.play()

func stop_sound() -> void:
	self.stop()

func _on_finished() -> void:
	play_sound_finished.emit()
