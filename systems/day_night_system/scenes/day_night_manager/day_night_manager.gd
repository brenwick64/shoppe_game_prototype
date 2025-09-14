extends Node

@onready var night_sounds: GlobalLoopSoundComponent = $GlobalLoopSoundComponent
@onready var day_sounds: GlobalRandomSoundComponent = $GlobalRandomSoundComponent
@onready var sound_transition: Timer = $SoundTransition

func _ready() -> void:
	if DayAndNightManager.is_day():
		day_sounds.fade_in()
	else:
		night_sounds.fade_in()
	DayAndNightManager.day_start.connect(_on_day_start)
	DayAndNightManager.night_start.connect(_on_night_start)

func _on_day_start() -> void:
	night_sounds.fade_out()
	sound_transition.start()
	await sound_transition.timeout
	day_sounds.fade_in()

func _on_night_start() -> void:
	day_sounds.fade_out()
	sound_transition.start()
	await sound_transition.timeout
	night_sounds.fade_in()
