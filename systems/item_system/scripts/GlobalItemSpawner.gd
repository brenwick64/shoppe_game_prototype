## GlobalItemSpawner.gd
extends Node

## -- public methods --
func spawn_item_pickup(item_id: int, start_pos: Vector2, end_pos: Vector2) -> void:
	var spawned_items: Node2D = _get_spawned_items()
	if not spawned_items: return
	var item_data: RItemData = _get_item_data(item_id)
	if not item_data: return
	
	var pickup_ins: ItemPickup = item_data.new_pickup()
	pickup_ins.global_position = start_pos
	pickup_ins.start_pos = start_pos
	pickup_ins.end_pos = end_pos
	spawned_items.add_child(pickup_ins)


## -- helper functions
func _get_spawned_items() -> Node2D:
	var spawned_items: Node2D = get_tree().get_first_node_in_group("spawned_items")
	if not spawned_items:
		push_error("GlobalItemSpawner error: no spawned_items node found in tree.")
	return spawned_items

func _get_item_data(item_id: int) -> RItemData:
	var item: RItemData = GlobalItemDb.get_item_by_id(item_id)
	if not item:
		push_error("GlobalItemSpawner error: no spawned_items node found in tree.")
	return item
