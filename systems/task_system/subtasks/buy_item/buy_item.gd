extends SubTask

@export var input_var_name: String

func on_physics_process(delta: float) -> void:
	super.on_physics_process(delta)
	_buy_item()
	super.complete(payload, reset_state)

func _buy_item() -> void:
	var target_item_node: Variant = payload[input_var_name]
	if not is_instance_valid(target_item_node):
		super.fail(self, payload, "retry_task")
		return
	target_item_node.buy_item()
