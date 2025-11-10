extends Node

var harvest_resource_task_scene: PackedScene = preload("res://systems/task_system/tasks/harvest_resource/harvest_resource.tscn")
var go_shopping_task_scene: PackedScene = preload("res://systems/task_system/tasks/go_shopping/go_shopping.tscn")
var pickup_quest_task: PackedScene = preload("res://systems/task_system/tasks/pickup_quest/pickup_quest.tscn")

func get_new_task() -> Task:
	var task_generator: Array[Callable] = [
		_get_go_shopping_task,
		_get_pickup_quest_task,
		_get_random_harvest_task
	]
	return task_generator.pick_random().call()

func _get_pickup_quest_task() -> Task:
	var pickup_quest_ins: Task = pickup_quest_task.instantiate()
	return pickup_quest_ins

func _get_go_shopping_task() -> Task:
	var go_shopping_ins: GoShopping = go_shopping_task_scene.instantiate()
	return go_shopping_ins

func _get_random_harvest_task() -> Task:
	var harvest_ins: HarvestResource = harvest_resource_task_scene.instantiate()
	var flip: bool = Utils.roll_percentage(0.5)
	harvest_ins.harvestable_type = "tree" if flip else "rock"
	harvest_ins.iterations = randi_range(1, 3)
	return harvest_ins
	
