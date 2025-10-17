extends SubTask

@export var asserted_boolean: bool = true
@export var exit_strategy: String
@export var input_var_name: String

func init(p_parent_task: Task, p_payload: Dictionary) -> void:
	super.init(p_parent_task, p_payload)
	var boolean: bool = p_payload[input_var_name]
	if boolean != asserted_boolean:
		super.fail(self, payload, exit_strategy)
		return
	super.complete(payload)
