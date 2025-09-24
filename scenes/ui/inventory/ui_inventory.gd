class_name UIInventory
extends Control

signal inventory_slot_updated(inv_slot: UIInventorySlot, inv_item: RInventoryItem)
signal inventory_slot_depleted(inv_slot: UIInventorySlot)

@onready var grid_container: GridContainer = $MainPanel/VBoxContainer/GridContainer


## -- public handlers --
func handle_item_added(new_item: RInventoryItem) -> void:
	var free_slot: UIInventorySlot = _get_inv_slot_by_id(-1)
	if not free_slot:
		push_warning("UIInventory failed to add item. no free slot available.") 
		return
	free_slot.add_item(new_item)
	inventory_slot_updated.emit(free_slot, new_item)

func handle_item_updated(item: RInventoryItem) -> void:
	var slot_to_update: UIInventorySlot = _get_inv_slot_by_id(item.item_id)
	if not slot_to_update:
		push_warning("UIInventory failed to update item. item slot not found.") 
		return
	slot_to_update.update_item_count(item.count)
	inventory_slot_updated.emit(slot_to_update, item)

func handle_item_depleted(item_id: int) -> void:
	var slot_to_deplete: UIInventorySlot = _get_inv_slot_by_id(item_id)
	if not slot_to_deplete:
		push_warning("UIInventory failed to deplete item. item slot not found.") 
		return
	slot_to_deplete.clear_item()
	inventory_slot_depleted.emit(slot_to_deplete)


## -- overrides --
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		_toggle_visible()


## -- helper functions --
func _get_inv_slot_by_id(item_id: int) -> UIInventorySlot:
	for node: Node in grid_container.get_children():
		if node is not UIInventorySlot: continue
		if node.item_id == item_id:
			return node
	return null
	
func _toggle_visible() -> void:
	self.visible = not self.visible
