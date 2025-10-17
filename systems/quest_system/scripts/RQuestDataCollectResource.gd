class_name RQuestDataCollectResource
extends RQuestData

@export var harvest_resource_task: PackedScene
@export var deposit_items_task: PackedScene


## -- public methods --
func new_quest(quest_config: Dictionary) -> Quest:
	var quest_ins: Quest = super.new_quest(quest_config)
	
	var harvestable: RHarvestableData = quest_config["harvestable"]
	var count: int = quest_config["count"]
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
