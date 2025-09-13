extends Control

@onready var sfx_slider: HSlider = $Panel/MarginContainer/VBoxContainer/SFXOption/Panel/HBoxContainer/SFXSlider
@onready var sfx_mute_btn: CheckButton = $Panel/MarginContainer/VBoxContainer/SFXOption/Panel/HBoxContainer/SFXMuteBtn

@onready var music_slider: HSlider = $Panel/MarginContainer/VBoxContainer/MusicOption/Panel/HBoxContainer/MusicSlider
@onready var music_mute_btn: CheckButton = $Panel/MarginContainer/VBoxContainer/MusicOption/Panel/HBoxContainer/MusicMuteBtn

@onready var ambience_slider: HSlider = $Panel/MarginContainer/VBoxContainer/AmbienceOption/Panel/HBoxContainer/AmbienceSlider
@onready var ambience_mute_btn: CheckButton = $Panel/MarginContainer/VBoxContainer/AmbienceOption/Panel/HBoxContainer/AmbienceMuteBtn

@onready var close_button: Button = $Panel/MarginContainer/VBoxContainer/CloseButton

func toggle_visible() -> void:
	self.visible = not self.visible

func _ready() -> void:
	sfx_mute_btn.toggled.connect(_on_sfx_toggled)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	music_slider.value_changed.connect(_on_music_changed)
	music_mute_btn.toggled.connect(_on_music_toggled)
	ambience_slider.value_changed.connect(_on_ambience_changed)
	ambience_mute_btn.toggled.connect(_on_ambience_toggled)
	close_button.pressed.connect(_on_close_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		toggle_visible()

## -- signals --
func _on_sfx_toggled(toggled_on: bool) -> void:
	GlobalAudioManager.set_bus_mute("sfx", toggled_on)

func _on_sfx_changed(new_value: float) -> void:
	var new_db_value: float = linear_to_db(new_value)
	GlobalAudioManager.set_bus_db("sfx", new_db_value)
	
func _on_music_toggled(toggled_on: bool) -> void:
	GlobalAudioManager.set_bus_mute("music", toggled_on)
	
func _on_music_changed(new_value: float) -> void:
	var new_db_value: float = linear_to_db(new_value)
	GlobalAudioManager.set_bus_db("music", new_db_value)

func _on_ambience_toggled(toggled_on: bool) -> void:
	GlobalAudioManager.set_bus_mute("ambience", toggled_on)
	
func _on_ambience_changed(new_value: float) -> void:
	var new_db_value: float = linear_to_db(new_value)
	GlobalAudioManager.set_bus_db("ambience", new_db_value)

func _on_close_pressed() -> void:
	self.visible = false
