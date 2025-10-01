extends Node

#TODO: migrate these to settings via get/set methods
const CURRENT_LOG_LEVEL: String = "DEBUG"
const INCLUDE_LEVEL_IN_MESSAGE: bool = true
const LOG_LEVELS: Array[String] = ["CHAT", "INFO", "DEBUG"]

var console_ui: UIConsole

func _ready() -> void:
	var console_ui_node: UIConsole = get_tree().get_first_node_in_group("console_ui")
	if not console_ui_node:
		push_error("GlobalMessageManager error: no UIConsole node found.")
	console_ui = console_ui_node


## -- public methods --
func add_message(level: String, message: String) -> void:
	var current_level_index: int = LOG_LEVELS.find(CURRENT_LOG_LEVEL)
	for i: int in range(current_level_index + 1):
		if level == LOG_LEVELS[i]:
			if INCLUDE_LEVEL_IN_MESSAGE:
				message = level + ": " + message
			console_ui.add_message(message)
