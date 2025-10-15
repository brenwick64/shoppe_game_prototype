extends SubTask

@export var method_name: String
@export var has_return_value: bool = false
@export var input_var_name: String
@export var output_var_name: String

func init(p_parent_task: Task, p_payload: Dictionary) -> void:
	super.init(p_parent_task, p_payload)
	var target_node: Node2D = p_payload[input_var_name]
	if not target_node.has_method(method_name):
		fail(self, payload, "kill_task")
	if has_return_value:
		payload[output_var_name] = target_node.callv(method_name, [parent_task.adventurer])
	else:
		target_node.callv(method_name, [parent_task.adventurer])
	super.complete(payload)
