extends SubTask

@export var output_var_name: String

var shoppe_items: ShoppeItems

func init(p_parent_task: Task, p_payload: Dictionary) -> void:
	super.init(p_parent_task, p_payload)
	var shoppe_items_node: Node2D = get_tree().get_first_node_in_group("shoppe_items")
	if not shoppe_items_node:
		push_error("error: no ShoppeItems node found in main tree.")
		super.fail(self, payload, "fail_task")
		return
	shoppe_items = shoppe_items_node

func on_physics_process(delta: float) -> void:
	super.on_physics_process(delta)
	var target_item: PlaceableItem = _get_random_item()
	if not target_item:
		super.fail(self, payload, "retry_subtask")
	else:
		payload.merge({ output_var_name: target_item })
		super.complete(payload)


## -- main function --
func _get_random_item() -> PlaceableItem:
	if not shoppe_items: return null
	return shoppe_items.shoppe_items.pick_random()
