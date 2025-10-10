class_name ChatManager
extends Node2D

@export var conversation_cooldown_sec: float = 60.0

@onready var parent_adventurer: Adventurer = $".."
@onready var chat_area: Area2D = $ChatArea
@onready var conversation_cooldown: Timer = $ConversationCooldown
@onready var chat_cooldown: Timer = $ChatCooldown
@onready var message_timer: Timer = $MessageTimer

var nearby_adventurers: Array[Node2D]
var nearby_adventurer_names: Array[String]

var _chat_cooldown: bool = false

## -- overrides --
func _ready() -> void:
	GlobalMessageManager.new_chat_message.connect(_on_global_new_chat_message)
	chat_area.area_entered.connect(_on_chat_area_entered)
	chat_area.area_exited.connect(_on_chat_area_exited)
	chat_cooldown.timeout.connect(_on_chat_cooldown_timeout)


## -- public methods --
func invoke_conversation_cooldown() -> void:
	conversation_cooldown.start(60)

func start_conversation(
	context: RMessageContext, 
	message_chance: float = Constants.GLOBAL_CHAT_CONVERSATION_CHANCE
	) -> void:
	# checks to start conversation
	if not Utils.roll_percentage(message_chance): return 
	if conversation_cooldown.time_left > 0.0: return
	if nearby_adventurers.is_empty(): return # nobody to chat to
	# get message from context
	var message_data: RMessageData = parent_adventurer.adventurer_persona.dialogue_data.get_conversation_starter(context)
	if not message_data: return
	# add data and send
	message_data.sender_name = parent_adventurer.adventurer_name
	message_data.recipient_names = nearby_adventurer_names
	GlobalMessageManager.add_chat_message(parent_adventurer, message_data)
	
	## invoke cd on self and nearby players to avoid multiple convo starters
	parent_adventurer.chat_manager.invoke_conversation_cooldown()
	for adventurer: Adventurer in nearby_adventurers:
		adventurer.chat_manager.invoke_conversation_cooldown()

func reply(
	replying_to: Adventurer, 
	message_context: RMessageContext, 
	message_chance: float = Constants.GLOBAL_CHAT_REPLY_CHANCE
	) -> void:
		
	if not Utils.roll_percentage(message_chance): return
	var message_data: RMessageData = parent_adventurer.adventurer_persona.dialogue_data.get_reply(message_context)
	if not message_data:
		return
	message_data.sender_name = parent_adventurer.adventurer_name
	message_data.recipient_names = [replying_to.adventurer_name]
	#FIXME: magic numbers
	message_timer.start(randf_range(2.5, 4.0))
	await message_timer.timeout
	GlobalMessageManager.add_chat_message(parent_adventurer, message_data)

func statement(
	message_context: RMessageContext,
	message_chance: float = Constants.GLOBAL_CHAT_STATEMENT_CHANCE
	) -> void:
		
	if not Utils.roll_percentage(message_chance): return
	var message_data: RMessageData = parent_adventurer.adventurer_persona.dialogue_data.get_statement(message_context)
	if not message_data:
		return
	message_data.sender_name = parent_adventurer.adventurer_name
	message_data.recipient_names = []
	#FIXME: magic numbers
	message_timer.start(randf_range(2.5, 4.0))
	await message_timer.timeout
	GlobalMessageManager.add_chat_message(parent_adventurer, message_data)


## -- helper functions
func _roll_message_chance(message_context: RMessageContext) -> bool:
	var message_chance: float = message_context.base_message_chance
	return Utils.roll_percentage(message_chance)


## -- signals --
func _on_global_new_chat_message(sender: Node2D, message_data: RMessageData) -> void:
	if sender == parent_adventurer: return # ignore your own messages
	if not parent_adventurer.adventurer_name in message_data.recipient_names: return # not in range of message
	if _chat_cooldown: return #TODO: make more complex
	if message_data.context.can_reply:
		_chat_cooldown = true
		chat_cooldown.start()
		reply(sender, message_data.context)

func _on_chat_cooldown_timeout() -> void:
	_chat_cooldown = false

func _on_chat_area_entered(area: Area2D) -> void:
	var area_parent: Node2D = area.get_parent()
	if area_parent == parent_adventurer: return
	if area_parent is Adventurer:
		nearby_adventurers.append(area_parent)
		nearby_adventurer_names.append(area_parent.adventurer_name)

func _on_chat_area_exited(area: Area2D) -> void:
	var area_parent: Node2D = area.get_parent()
	if area_parent == parent_adventurer: return
	if area_parent is Adventurer:
		# removes from adventurer list
		var adv_remove_index: int = nearby_adventurers.find(area_parent)
		nearby_adventurers.remove_at(adv_remove_index)
		# remove from name list
		var name_remove_index: int = nearby_adventurer_names.find(area_parent.adventurer_name)
		nearby_adventurer_names.remove_at(name_remove_index)
