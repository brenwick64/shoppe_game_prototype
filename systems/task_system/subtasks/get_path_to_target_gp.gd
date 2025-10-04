extends SubTask

func on_physics_process(delta: float) -> void:
	super.on_physics_process(delta)
	_set_target_path()
	super.complete(payload)


## -- main function --
func _set_target_path() -> void:
	var target_gp: Vector2 = payload["target_gp"]
	# TODO: fail
	if not target_gp: return
	parent_task.adventurer.nav_agent.target_position = target_gp
