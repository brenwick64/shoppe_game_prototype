extends SubTask

@export var input_var_name: String

func on_physics_process(delta: float) -> void:
	super.on_physics_process(delta)
	_buy_item()
	super.complete(payload, reset_state)

func _buy_item() -> void:
	var target_item_node: PlaceableItem = payload[input_var_name]
	target_item_node.buy_item()
