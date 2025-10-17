extends SubTask

@export var has_return_value: bool = false
@export var input_var_name: String
@export var output_var_name: String

func init(p_parent_task: Task, p_payload: Dictionary) -> void:
	super.init(p_parent_task, p_payload)
	var target_node: Node2D = p_payload[input_var_name]
	if has_return_value:
		payload[output_var_name] = target_node.deposit_items(parent_task.item_id, parent_task.count)
	else:
		target_node.deposit_items(parent_task.adventurer, parent_task.item_id, parent_task.count)
	super.complete(payload)
