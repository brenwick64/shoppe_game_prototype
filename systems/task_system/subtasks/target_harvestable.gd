extends SubTask

func on_physics_process(delta: float) -> void:
	super.on_physics_process(delta)
	payload.merge({ "target_node": _get_target_harvestable() })
	super.complete(payload)


## -- main function --
func _get_target_harvestable() -> Harvestable:
	var harvestables: Array[Node] = get_tree().get_nodes_in_group("harvestable")
	var filtered_harvestables: Array[Node] = harvestables.filter(
		func(harvestable: Node): return harvestable.harvestable_type == parent_task.harvestable_type
	)
	var target_harvestable: Harvestable = filtered_harvestables.pick_random()
	return target_harvestable
