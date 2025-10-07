class_name ChatMessage
extends Label

signal deleted(message_id: String)

@onready var despawn_timer: Timer = $DespawnTimer

const Y_OFFSET: float = -65.0

var message_id: String
var message_owner: Node2D
var message: String

## -- public methods --
func delete() -> void:
	despawn_timer.stop()
	deleted.emit(message_id)
	queue_free()


## -- overrides --
func _ready() -> void:
	self.text = message
	message_id = uuid.v4()
	
	despawn_timer.timeout.connect(_on_despawn_timer_timeout)
	despawn_timer.start(Constants.CHAT_MESSAGE_ALIVE_TIME_SEC)

func _process(_delta: float) -> void:
	if !is_instance_valid(message_owner): return
	
	var canvas_transform: Transform2D = get_viewport().get_canvas_transform()
	var screen_pos: Vector2 = canvas_transform * message_owner.global_position
	var x_offset: float = size.x / 2.0
	position = screen_pos + Vector2(-x_offset, Constants.CHAT_MESSAGE_Y_OFFSET)


## -- signals --
func _on_despawn_timer_timeout() -> void:
	deleted.emit(message_id)
	queue_free()
