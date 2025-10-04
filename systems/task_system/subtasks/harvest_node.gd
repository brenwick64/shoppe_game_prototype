extends SubTask

func on_physics_process(delta: float) -> void:
	super.on_physics_process(delta)
	_harvest_node()
	super.complete(payload)


## - main function --
func _harvest_node() -> void:
	var target_node: Node2D = payload["target_node"]
	# TODO: fail
	if not target_node: return
	if target_node is not Harvestable: return
	target_node.harvest()
