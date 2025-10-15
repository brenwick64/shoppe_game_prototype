extends Panel

@onready var debug_quest_desc: PackedScene = preload("res://scenes/objects/quest_board/debug_quest_desc.tscn")
@onready var v_box_container: VBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer

func _ready() -> void:
	self.visible = get_parent().debug_show_quest_list

func update_list(quests: Array[Quest]) -> void:
	for child: Node in v_box_container.get_children():
		child.queue_free()
	for quest: Quest in quests:
		var quest_entry: HBoxContainer = debug_quest_desc.instantiate()
		quest_entry.quest_name = quest.quest_name
		quest_entry.quest_owner = quest.quest_owner
		quest_entry.quest_status = Constants.QUEST_STATUS.find_key(quest.quest_status)
		v_box_container.add_child(quest_entry)
