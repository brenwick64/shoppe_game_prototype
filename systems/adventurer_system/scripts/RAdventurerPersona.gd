class_name RAdventurerPersona
extends Resource

@export var name_options: Array[String]
@export var spritesheets: Array[Texture]
@export var chat_options: Array[String]

func get_random_spritesheet() -> Texture:
	return spritesheets.pick_random()

func get_random_name() -> String:
	return name_options.pick_random()

func get_chat_message() -> String:
	return chat_options.pick_random()
