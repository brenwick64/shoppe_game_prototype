class_name LootableComponent
extends Node

signal items_changed(lootable_items: RInventoryItem)

var lootable_items: Array[RInventoryItem]


## -- public methods --
func deposit_items(item_id: int, count: int) -> void:
	var item_index: int = _get_item_index(item_id)
	if item_index == -1:
		_add_inv_item(item_id, count)
	else:
		_update_inv_item(item_index, count)
	items_changed.emit(lootable_items)

func loot_all_items() -> Array[RInventoryItem]:
	var looted_items: Array[RInventoryItem] = lootable_items
	lootable_items = []
	items_changed.emit(lootable_items)
	return looted_items


## -- helper functions --
func _get_item_index(item_id: int) -> int:
	for inv_item: RInventoryItem in lootable_items:
		if inv_item.item_id == item_id:
			return lootable_items.find(inv_item)
	return -1

func _add_inv_item(item_id: int, count: int) -> void:
	var inv_item: RInventoryItem = RInventoryItem.new()
	inv_item.item_id = item_id
	inv_item.count = count
	lootable_items.append(inv_item)

func _update_inv_item(item_index: int, count: int) -> void:
	var inv_item: RInventoryItem = lootable_items[item_index]
	inv_item.count += count
