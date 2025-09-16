extends Node

@onready var day_birds_random: GlobalRandomSoundComponent = $DayBirdsRandom
@onready var night_crickets_loop: GlobalLoopSoundComponent = $NightCricketsLoop
@onready var night_owl_random: GlobalRandomSoundComponent = $NightOwlRandom
@onready var sound_transition: Timer = $SoundTransition

func _ready() -> void:
	if DayAndNightManager.is_day():
		_fade_in_day()
	else:
		_fade_in_night()
	DayAndNightManager.day_start.connect(_on_day_start)
	DayAndNightManager.night_start.connect(_on_night_start)

func _fade_in_day() -> void:
	day_birds_random.fade_in()
	
func _fade_out_day() -> void:
	day_birds_random.fade_out()

func _fade_in_night() -> void:
	night_crickets_loop.fade_in()
	night_owl_random.fade_in()
	
func _fade_out_night() -> void:
	night_crickets_loop.fade_out()
	night_owl_random.fade_out()

## -- signals --
func _on_day_start() -> void:
	_fade_out_night()
	sound_transition.start()
	await sound_transition.timeout
	_fade_in_day()

func _on_night_start() -> void:
	_fade_out_day()
	sound_transition.start()
	await sound_transition.timeout
	_fade_in_night()
