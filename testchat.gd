extends State

@export var parent: Node2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var chat_label: ChatLabel

@onready var chat_cooldown: Timer = $ChatCooldown

var _is_chat_cooldown: bool = false

## -- overrides --
func _ready() -> void:
	chat_cooldown.timeout.connect(_on_chat_cooldown_timeout)

func _on_enter() -> void:
	if not _is_chat_cooldown:
		var message: String = parent.adventurer_persona.get_chat_message()
		chat_label.chat(message)
		_is_chat_cooldown = true
		chat_cooldown.start(randf_range(10, 30))
	transition.emit("idle")

func _on_exit() -> void:
	animated_sprite_2d.stop()


## - signals --
func _on_chat_cooldown_timeout() -> void:
	_is_chat_cooldown = false
