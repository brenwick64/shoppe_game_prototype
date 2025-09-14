extends MarginContainer

@export var audio_bus_name: String

@onready var label: Label = $Panel/HBoxContainer/MarginContainer/Label
@onready var h_slider: HSlider = $Panel/HBoxContainer/HSlider
@onready var mute_btn: CheckButton = $Panel/HBoxContainer/MuteBtn

func _ready() -> void:
	# set initial values
	label.text = audio_bus_name.capitalize()
	_set_initial_slider()
	_set_initial_mute()
	# connect signals
	h_slider.value_changed.connect(_on_slider_value_changed)
	mute_btn.toggled.connect(_on_mute_toggled)

## -- helper functions --
func _set_initial_slider() -> void:
	var db_value: float = GlobalAudioManager.get_bus_db(audio_bus_name)
	h_slider.value = db_to_linear(db_value)

func _set_initial_mute() -> void:
	var is_muted: bool = GlobalAudioManager.get_bus_mute(audio_bus_name)
	mute_btn.button_pressed = not is_muted # shows pressed when sound is on

## -- signals --
func _on_slider_value_changed(new_value: float) -> void:
	GlobalAudioManager.set_bus_db(audio_bus_name, linear_to_db(new_value))

func _on_mute_toggled(toggled_on: bool) -> void:
	GlobalAudioManager.set_bus_mute(audio_bus_name, not toggled_on)
