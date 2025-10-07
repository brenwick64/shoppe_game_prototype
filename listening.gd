extends State

@export var parent: Adventurer
@export var chat_manager: ChatManager

@onready var start_conversation_cooldown: Timer = $ConversationCooldown


## -- public methods --
func invoke_conversation_cd() -> void:
	start_conversation_cooldown.start()


## -- overrides --
func _ready() -> void:
	chat_manager.new_chat_message.connect(_on_new_chat_message)
	start_conversation_cooldown.timeout.connect(_on_conversation_cooldown)


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

func _on_conversation_cooldown() -> void:
	if start_conversation_cooldown.time_left <= 0: return
	transition.emit("startingconversation")
