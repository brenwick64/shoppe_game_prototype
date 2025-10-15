extends SubTask

@export var group_name: String
@export var output_var_name: String

func init(p_parent_task: Task, p_payload: Dictionary) -> void:
	super.init(p_parent_task, p_payload)
	var target_node: Node2D = get_tree().get_first_node_in_group(group_name)
	if not target_node:
		push_error("SubTask error (get node from group name): no node found for group: " + group_name)
		failed.emit(self, payload, "kill_task")
		return
	payload[output_var_name] = target_node
	super.complete(payload)
