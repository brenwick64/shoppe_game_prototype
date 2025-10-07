extends SubTask

@export var input_var_name: String


func on_physics_process(delta: float) -> void:
	super.on_physics_process(delta)
	_set_target_path()
	super.complete(payload)


## -- main function --
func _set_target_path() -> void:
	var target_gp: Vector2 = payload[input_var_name]
	parent_task.adventurer.nav_agent.target_position = target_gp
