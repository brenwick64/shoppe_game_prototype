extends SubTask

@export var output_var_name: String


func on_physics_process(delta: float) -> void:
	super.on_physics_process(delta)
	var target_harvestable: Harvestable = _get_target_harvestable()
	if not target_harvestable:
		super.fail(self, payload, "retry_subtask")
	else:
		payload.merge({ output_var_name: target_harvestable })
		super.complete(payload)


## -- main function --
func _get_target_harvestable() -> Harvestable:
	var harvestables: Array[Harvestable] = []
	var harvestable_nodes: Array[Node] = get_tree().get_nodes_in_group("harvestable")
	for node: Node in harvestable_nodes:
		if node is Harvestable:
			harvestables.append(node)
	harvestables = _filter_harvestables_by_type(harvestables, parent_task.harvestable_type)
	harvestables = _filter_harvestables_by_depleted(harvestables)
	#var closest_harvestable: Harvestable = _get_closest_harvestable(harvestables)
	var random_harvestable: Harvestable = harvestables.pick_random()
	return random_harvestable
	

## -- helper functions --
func _filter_harvestables_by_type(harvestables: Array[Harvestable], type: String) -> Array[Harvestable]:
	var filtered_harvestables: Array[Harvestable] = harvestables.filter(
		func(harvestable: Harvestable): return harvestable.harvestable_type == type
	)
	return filtered_harvestables

func _filter_harvestables_by_depleted(harvestables: Array[Harvestable]) -> Array[Harvestable]:
	var filtered_harvestables: Array[Harvestable] = harvestables.filter(
		func(harvestable: Harvestable): return not harvestable.is_depleted()
	)
	return filtered_harvestables

func _get_closest_harvestable(harvestables: Array[Harvestable]) -> Harvestable:
	var harvestable_nodes: Array[Node2D] = []
	for harvestable: Harvestable in harvestables:
		if harvestable is Node2D:
			harvestable_nodes.append(harvestable)
	var closest_node: Node2D = Utils.get_closest_target_node(parent_task.adventurer, harvestable_nodes)
	return closest_node as Harvestable
