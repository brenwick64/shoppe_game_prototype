extends State

@export var parent: Adventurer
@export var chat_manager: ChatManager

## -- overrides --
func _ready() -> void:
	chat_manager.new_chat_message.connect(_on_new_chat_message)


## -- helper functions --
func _handle_direct_message(sender: Node2D, message: String, context: Dictionary, recipent: Node2D) -> void:
	if recipent != parent: return # message for someone else
	if not sender in chat_manager.nearby_adventurers: return # too far away to talk to
	
func _handle_indirect_message(sender: Node2D, message: String, context: Dictionary) -> void:
	pass


## -- signals --
func _on_new_chat_message(sender: Node2D, message: String, context: Dictionary) -> void:
	var recipient: Node2D = context["recipient"]
	if recipient:
		_handle_direct_message(sender, message, context, recipient)
	else:
		_handle_indirect_message(sender, message, context)
