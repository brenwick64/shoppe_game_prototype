extends SubTask

@export var input_var_name: String

func on_physics_process(delta: float) -> void:
	super.on_physics_process(delta)
	_set_target_path()
	super.complete(payload)


## -- main function --
func _set_target_path() -> void:
	var pickup_node: ItemPickup = payload[input_var_name]
	# TODO: fail
	if not pickup_node: return
	parent_task.adventurer.nav_agent.target_position = pickup_node.end_pos
