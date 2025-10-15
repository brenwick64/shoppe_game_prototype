extends SubTask

@export var input_var_name: String
@export var output_var_name: String

func init(p_parent_task: Task, p_payload: Dictionary) -> void:
	super.init(p_parent_task, p_payload)
	var parent_node: Node2D = p_payload[input_var_name]
	var marker_gp: Vector2 = parent_node.navigation_marker.global_position
	payload[output_var_name] = marker_gp
	super.complete(payload)
