extends HBoxContainer

@onready var quest_name_label: Label = $QuestNameLabel
@onready var quest_owner_label: Label = $QuestOwnerLabel
@onready var quest_status_label: Label = $QuestStatusLabel


var quest_name: String
var quest_owner: Variant
var quest_status: String

func _ready() -> void:
	quest_name_label.text = quest_name
	if quest_owner:
		quest_owner_label.text = quest_owner.adventurer_name
	quest_status_label.text = quest_status
