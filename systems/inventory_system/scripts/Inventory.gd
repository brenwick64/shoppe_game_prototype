class_name Inventory
extends Node

signal item_aquired(item_id: int, count: int)
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

func has_item_id(item_id: int) -> bool:
	for inv_item: RInventoryItem in inventory_items:
		if inv_item.item_id == item_id: return true
	return false

func has_items(inv_items: Array[RInventoryItem]) -> bool:
	for inv_item: RInventoryItem in inv_items:
		var matched_item_arr: Array[RInventoryItem] = inventory_items.filter(
			func(i: RInventoryItem): return i.item_id == inv_item.item_id
		)
		# case 1 - item doesnt exist
		if not matched_item_arr: return false
		# case 2 - not enough
		if matched_item_arr[0].count < inv_item.count: return false
	return true

func add_item(item_id: int, count: int) -> void:
	item_aquired.emit(item_id, count)
	var item_index: int = _get_item_index(item_id)
	if item_index == -1: # new item
		var added_item: RInventoryItem = _insert_item(item_id, count)
		item_added.emit(added_item)
	else: # existing item
		var updated_item: RInventoryItem = _update_item(count, item_index)
		if updated_item.count > 0:
			item_updated.emit(updated_item)
		else:
			item_depleted.emit(updated_item.item_id)
	var item_data: RItemData = GlobalItemDb.get_item_by_id(item_id)
	GlobalMessageManager.add_console_message(
		"DEBUG", 
		"added " + str(count) + " x " + item_data.item_name
	) 

func add_items(inv_items: Array[RInventoryItem]) -> void:
	for inv_item: RInventoryItem in inv_items:
		add_item(inv_item.item_id, inv_item.count)

func remove_item(item_id: int, count: int) -> void:
	var item_data = GlobalItemDb.get_item_by_id(item_id)
	var item_index: int = _get_item_index(item_id)
	if item_index == -1:
		push_error("Inventory error: attempted to remove non existing item.")
	var updated_item: RInventoryItem = _update_item((count * -1), item_index)
	if updated_item.count > 0:
		item_updated.emit(updated_item)
	else:
		_prune_depleted_items()
		item_depleted.emit(updated_item.item_id)

func remove_items(inv_items: Array[RInventoryItem]) -> void:
	for inv_item: RInventoryItem in inv_items:
		remove_item(inv_item.item_id, inv_item.count)


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

func _update_item(count: int, index: int) -> RInventoryItem:
	if inventory_items.size() < index:
		push_error("Inventory error: out of bounds index check for _update_item")
		return
	var inv_item: RInventoryItem = inventory_items[index]
	var new_count: int = max(inv_item.count + count, 0)
	inv_item.count = new_count
	return inv_item
