class_name Inventory
extends Node

signal item_added(inv_item: RInventoryItem)
signal item_updated(inv_item: RInventoryItem)
signal item_depleted(item_id: int)

var uuid: String
var inventory_items: Array[RInventoryItem] = []

##  -- public methods --
func get_inventory() -> Array[RInventoryItem]:
	return inventory_items

func get_inventory_item(item_id: int) -> RInventoryItem:
	var item_index: int = _get_item_index(item_id)
	if item_index == -1:
		return null
	return inventory_items[item_index]

func add_item(item_id: int, count: int) -> void:
	var item_index: int = _get_item_index(item_id)
	if item_index == -1: # new item
		var added_item: RInventoryItem = _insert_item(item_id, count)
		item_added.emit(added_item)
	else: # existing item
		var updated_item: RInventoryItem = _update_item(item_id, count, item_index)
		if updated_item.count > 0:
			item_updated.emit(updated_item)
		else:
			item_depleted.emit(updated_item.item_id)

func remove_item(item_id: int, count: int) -> void:
	var item_index: int = _get_item_index(item_id)
	if not item_index:
		push_error("Inventory error: attempted to remove non existing item.")
	var updated_item: RInventoryItem = _update_item(item_id, (count * -1), item_index)
	if updated_item.count > 0:
		item_updated.emit(updated_item)
	else:
		_prune_depleted_items()
		item_depleted.emit(updated_item.item_id)

## -- helper functions --
func _prune_depleted_items() -> void:
	inventory_items = inventory_items.filter(
		func(item: RInventoryItem): return item.count > 0)


func _get_item_index(item_id: int) -> int:
	for i: int in inventory_items.size():
		var inv_item: RInventoryItem = inventory_items[i]
		if inv_item.item_id == item_id:
			return i
	return -1

func _insert_item(item_id: int, count: int) -> RInventoryItem:
	var new_inv_item: RInventoryItem = RInventoryItem.new()
	new_inv_item.item_id = item_id
	new_inv_item.count = count
	inventory_items.append(new_inv_item)
	return new_inv_item

func _update_item(item_id: int, count: int, index: int) -> RInventoryItem:
	if inventory_items.size() < index:
		push_error("Inventory error: out of bounds index check for _update_item")
		return
	var inv_item: RInventoryItem = inventory_items[index]
	var new_count: int = max(inv_item.count + count, 0)
	inv_item.count = new_count
	return inv_item
