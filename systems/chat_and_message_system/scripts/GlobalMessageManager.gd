extends Node

signal new_chat_message(sender: Node2D, message_data: RMessageData)

#TODO: migrate these to settings via get/set methods
const CURRENT_LOG_LEVEL: String = "DEBUG"
const INCLUDE_LEVEL_IN_MESSAGE: bool = false
const LOG_LEVELS: Array[String] = ["CHAT", "INFO", "DEBUG"]

var console_ui: UIConsole
var chat_messages_ui: ChatMessagesUI

func _ready() -> void:
	var console_ui_node: UIConsole = get_tree().get_first_node_in_group("console_ui")
	if not console_ui_node:
		push_error("GlobalMessageManager error: no UIConsole node found.")
	console_ui = console_ui_node
	
	var chat_messages_ui_node: CanvasLayer = get_tree().get_first_node_in_group("chat_messages_ui")
	if not chat_messages_ui_node:
		push_error("GlobalMessageManager error: no ChatMessagesUI node found.")
	chat_messages_ui = chat_messages_ui_node


func _get_default_color(log_level: String) -> Color:
	match log_level:
		"DEBUG": return Constants.CONSOLE_TEXT_DEBUG
		"INFO": return Constants.CONSOLE_TEXT_INFO
		"CHAT": return Constants.CONSOLE_TEXT_CHAT
	return Constants.CONSOLE_TEXT_DEFAULT


## -- public methods --
func add_console_message(level: String, message: String, optional_color: Color = _get_default_color(level)) -> void:
	if not console_ui: return
	var current_level_index: int = LOG_LEVELS.find(CURRENT_LOG_LEVEL)
	for i: int in range(current_level_index + 1):
		if level == LOG_LEVELS[i]:
			if INCLUDE_LEVEL_IN_MESSAGE:
				message = level + ": " + message
			console_ui.add_message(message, optional_color)

func add_chat_message(sender: Node2D, message_data: RMessageData) -> void:
	if not console_ui: return
	_render_console_chat_message(message_data.sender_name, message_data.message)
	if not chat_messages_ui: return
	_render_ui_chat_message(sender, message_data.message)
	new_chat_message.emit(sender, message_data)


## -- helper functions --
func _render_console_chat_message(sender_name: String, message: String) -> void:
	var chat_color_hex: String = Constants.CONSOLE_TEXT_CHAT.to_html()
	var sender_color_hex: String = Constants.CONSOLE_TEXT_CHAT_SENDER.to_html() 
	var sender_str: String = "[color=" + sender_color_hex + "]" + sender_name + ": " + "[/color]"
	var message_str: String = "[color=" + chat_color_hex + "]" + message + "[/color]"
	console_ui.add_message(sender_str + message_str)

func _render_ui_chat_message(sender: Node2D, message: String) -> void:
	chat_messages_ui.add_message(sender, message)
