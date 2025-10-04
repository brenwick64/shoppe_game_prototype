class_name ChatLabel
extends Label

@export var parent: Adventurer

@onready var chat_timer: Timer = $ChatTimer

func _ready() -> void:
	chat_timer.timeout.connect(_on_chat_timer_timeout)


## -- public methods --
func chat(message: String) -> void:
	text = message
	GlobalMessageManager.add_chat_message(parent.adventurer_name, message)
	chat_timer.start()

## -- signals --
func _on_chat_timer_timeout() -> void:
	text = ""
