class_name ChatMessagesUI
extends CanvasLayer

@onready var chat_message_scene: PackedScene = preload("res://systems/chat_and_message_system/scenes/chat_message/chat_message.tscn")

var current_messages: Array[ChatMessage]

## -- public methods --
func add_message(sender: Node2D, message: String) -> void:
	_remove_existing_sender_message(sender)
	var new_message: ChatMessage = _new_chat_message(sender, message)
	new_message.deleted.connect(_on_message_deleted)
	current_messages.append(new_message)
	add_child(new_message)


## -- helper functions --
func _new_chat_message(sender: Node2D, message: String) -> ChatMessage:
	var message_ins: ChatMessage = chat_message_scene.instantiate()
	message_ins.message_owner = sender
	message_ins.message = message
	return message_ins

func _remove_existing_sender_message(sender: Node2D) -> void:
	for message: ChatMessage in current_messages:
		if message.message_owner == sender:
			message.delete()


## -- signals --
func _on_message_deleted(message_id: String) -> void:
	var cleared_messages: Array[ChatMessage] = current_messages.filter(
		func(msg: ChatMessage): return msg.message_id != message_id
	)
	current_messages = cleared_messages
