class_name UIActionbar
extends Control

@onready var h_box_container: HBoxContainer = $MainPanel/HBoxContainer


func _on_ui_inventory_inventory_slot_updated(inv_slot: UIInventorySlot, inv_item: RInventoryItem) -> void:
	var matching_slot: UIInventorySlot = _get_slot_by_index(inv_slot.index)
	if not matching_slot: return
	
	matching_slot.add_item(inv_item)
	matching_slot.update_item_count(inv_item.count)

func _on_ui_inventory_inventory_slot_depleted(inv_slot: UIInventorySlot) -> void:
	var matching_slot: UIInventorySlot = _get_slot_by_index(inv_slot.index)
	if not matching_slot: return
	
	matching_slot.clear_item()

## -- helper functions --
func _get_slot_by_index(index: int) -> UIInventorySlot:
	for node: Node in h_box_container.get_children():
		if node is not UIActionBarSlot: continue
		if node.index == index:
			return node
	return null
