extends SubTask

@export var input_var_name: String
@export var output_var_name: String

func on_physics_process(delta: float) -> void:
	super.on_physics_process(delta)
	payload.merge({ output_var_name: _get_node_gp() })
	super.complete(payload)


## -- main function --
func _get_node_gp() -> Vector2:
	var node_2d: Node2D = payload[input_var_name]
	return node_2d.global_position
