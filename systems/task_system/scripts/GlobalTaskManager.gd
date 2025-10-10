extends Node

var harvest_resource_task_scene: PackedScene = preload("res://systems/task_system/tasks/harvest_resource/harvest_resource.tscn")
var go_shopping_task_scene: PackedScene = preload("res://systems/task_system/tasks/go_shopping/go_shopping.tscn")

func get_new_task() -> Task:
	var flip: bool = Utils.roll_percentage(0.5)
	return _get_go_shopping_task() if flip else _get_random_harvest_task()

func _get_go_shopping_task() -> Task:
	var go_shopping_ins: GoShopping = go_shopping_task_scene.instantiate()
	return go_shopping_ins

func _get_random_harvest_task() -> Task:
	var harvest_ins: HarvestResource = harvest_resource_task_scene.instantiate()
	var flip: bool = Utils.roll_percentage(0.5)
	harvest_ins.harvestable_type = "tree" if flip else "rock"
	harvest_ins.iterations = randi_range(1, 3)
	return harvest_ins
