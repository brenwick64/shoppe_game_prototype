extends Control

@onready var close_button: Button = $Panel/MarginContainer/VBoxContainer/CloseButton

func _ready() -> void:
	close_button.pressed.connect(_on_close_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		toggle_visible()

func toggle_visible() -> void:
	if self.visible:
		GlobalAudioManager.save_bus_layout()
	self.visible = not self.visible

## -- signals --
func _on_close_pressed() -> void:
	self.visible = false
	GlobalAudioManager.save_bus_layout()
