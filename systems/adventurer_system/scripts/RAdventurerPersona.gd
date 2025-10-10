class_name RAdventurerPersona
extends Resource

@export var name_options: Array[String]
@export var spritesheets: Array[Texture]
@export var chat_options: Array[String]
@export var dialogue_data: RDialogueData


func get_new_name(current_adventurers: Array[Adventurer]) -> String:
	name_options.shuffle()
	for name: String in name_options:
		var name_taken: bool = false
		for adventurer: Adventurer in current_adventurers:
			if adventurer.adventurer_name == name: 
				name_taken = true
		if not name_taken:
			return name
	return "Error no new Names"

func get_random_spritesheet() -> Texture:
	return spritesheets.pick_random()

func get_random_name() -> String:
	return name_options.pick_random()

func get_chat_message() -> String:
	return chat_options.pick_random()
