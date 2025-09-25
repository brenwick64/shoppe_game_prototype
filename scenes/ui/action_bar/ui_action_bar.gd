class_name UIActionbar
extends Control

signal item_focused(item_id: int)

@onready var h_box_container: HBoxContainer = $MainPanel/HBoxContainer

var action_bar_slots: Array[UIActionBarSlot]

func _ready() -> void:
	for node: Node in h_box_container.get_children():
		if node is not UIActionBarSlot: continue
		node.slot_focused.connect(_on_slot_focused)
		action_bar_slots.append(node)


## -- helper functions --
func _get_slot_by_index(index: int) -> UIActionBarSlot:
	for slot: UIActionBarSlot in action_bar_slots:
		if slot.index == index:
			return slot
	return null


## -- signals --
func _on_ui_inventory_inventory_slot_updated(inv_slot: UIInventorySlot, inv_item: RInventoryItem) -> void:
	var matching_slot: UIActionBarSlot = _get_slot_by_index(inv_slot.index)
	if not matching_slot: return
	
	matching_slot.add_item(inv_item)
	matching_slot.update_item_count(inv_item.count)

func _on_ui_inventory_inventory_slot_depleted(inv_slot: UIInventorySlot) -> void:
	var matching_slot: UIActionBarSlot = _get_slot_by_index(inv_slot.index)
	if not matching_slot: return
	
	matching_slot.clear_item()

func _on_slot_focused(focused_slot: UIActionBarSlot) -> void:
	focused_slot.set_focus(true)
	for slot: UIActionBarSlot in action_bar_slots:
		if slot.index != focused_slot.index:
			slot.set_focus(false)
	item_focused.emit(focused_slot.item_id)
