## GlobalQuestManager autoload
extends Node

@onready var harvest_resource_task: PackedScene = preload("res://systems/task_system/tasks/harvest_resource/harvest_resource.tscn")
@onready var deposit_items_task: PackedScene = preload("res://deposit_quest_crate.tscn")
@onready var complete_quest_task: PackedScene = preload("res://systems/task_system/tasks/complete_quest/complete_quest.tscn")

## -- public methods --
func new_quest(quest_key: String, quest_config: Dictionary) -> Quest:
	match quest_key:
		"harvest_resource": return _new_harvest_quest(quest_config)
	return null


## -- helper functions --
func _new_harvest_quest(quest_config: Dictionary) -> Quest:
	var quest_ins: Quest = Quest.new()
	# unpack config
	var harvestable: RHarvestableData = quest_config["harvestable"]
	var count: int = quest_config["count"]
	# set initial params
	quest_ins.quest_name = "harvest " + str(count) + " " + harvestable.harvestable_name
	quest_ins.quest_status = Constants.QUEST_STATUS.NONE
	# build task chain
	quest_ins.quest_steps = [
		_new_harvest_resource_task(harvestable, count),
		_new_deposit_items_task(harvestable, count),
		_new_complete_quest_task()
	]
	return quest_ins


## -- helper functions --
func _new_harvest_resource_task(harvestable: RHarvestableData, count: int) -> Task:
	var harvest_task_ins: Task = harvest_resource_task.instantiate()
	harvest_task_ins.harvestable_type = harvestable.harvestable_name
	harvest_task_ins.iterations = count
	return harvest_task_ins

func _new_deposit_items_task(harvestable: RHarvestableData, count: int) -> Task:
	var deposit_items_ins: Task = deposit_items_task.instantiate()
	deposit_items_ins.item_id = harvestable.drop_data.item_id
	deposit_items_ins.count = count
	return deposit_items_ins

func _new_complete_quest_task() -> Task:
	var complete_quest: CompleteQuest = complete_quest_task.instantiate()
	return complete_quest
