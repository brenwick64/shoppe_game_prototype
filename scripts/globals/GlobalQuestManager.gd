## GlobalQuestManager autoload
extends Node

@onready var harvest_resource_task: PackedScene = preload("res://systems/task_system/tasks/harvest_resource/harvest_resource.tscn")
@onready var complete_quest_task: PackedScene = preload("res://systems/task_system/tasks/complete_quest/complete_quest.tscn")

## -- public methods --
func new_harvest_quest(harvestable_type: String, count: int) -> Quest:
	var quest_ins: Quest = Quest.new()
	var harvest_task_ins: Task = harvest_resource_task.instantiate()
	harvest_task_ins.harvestable_type = harvestable_type
	harvest_task_ins.iterations = count
	quest_ins.quest_name = "harvest " + str(count) + " " + harvestable_type
	quest_ins.quest_status = Constants.QUEST_STATUS.NONE
	quest_ins.quest_steps = [harvest_task_ins]
	return _add_complete_quest_task(quest_ins)

func _add_complete_quest_task(quest: Quest) -> Quest:
	var complete_quest: CompleteQuest = complete_quest_task.instantiate()
	quest.quest_steps.append(complete_quest)
	return quest
