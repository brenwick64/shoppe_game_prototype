class_name RQuestData
extends Resource

var complete_quest_task: PackedScene = preload("res://systems/task_system/tasks/complete_quest/complete_quest.tscn")

@export var quest_name: String
@export var base_cost_gold: int
@export var ui_config_scene: PackedScene


## -- public methods --
func new_quest(quest_config: Dictionary) -> Quest:
	var quest_ins: Quest = Quest.new()
	quest_ins.quest_name = quest_name
	quest_ins.quest_status = Constants.QUEST_STATUS.NONE
	return quest_ins


## -- helper functions --
func _new_complete_quest_task() -> Task:
	var complete_quest: CompleteQuest = complete_quest_task.instantiate()
	return complete_quest
