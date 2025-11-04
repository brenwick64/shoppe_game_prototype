class_name UIActionbar
extends Control

signal item_focused(item_id: int)

@onready var h_box_container: HBoxContainer = $MainPanel/HBoxContainer
@onready var save_load_component: SaveLoadComponent = $SaveLoadComponent

var action_bar_slots: Array[UIActionBarSlot]

func _ready() -> void:
	# create action bar slots
	for node: Node in h_box_container.get_children():
		if node is not UIActionBarSlot: continue
		node.slot_focused.connect(_on_slot_focused)
		action_bar_slots.append(node)
		
	# load action bar mapping data
	var mappings_exist: bool = save_load_component.check_save_data() 
	if mappings_exist:
		var mappings: Array = save_load_component.load_data()
		_load_action_bar_slot_mappings(mappings)


## -- helper functions --
func _get_slot_by_index(index: int) -> UIActionBarSlot:
	for slot: UIActionBarSlot in action_bar_slots:
		if slot.index == index:
			return slot
	return null


## -- save / load --
func _save_action_bar_slot_mappings() -> void:
	save_load_component.save_data(action_bar_slots)

func _load_action_bar_slot_mappings(mappings: Array) -> void:
	for mapping in mappings:
		# item no longer exists
		if not GlobalPlayerInventory.has_item_id(mapping.item_id):
			mapping.item_id = -1
		# slot already defaults to this value
		if mapping.item_id == -1: continue
		for slot: UIActionBarSlot in action_bar_slots:
			if mapping.index == slot.index:
				slot.item_id = mapping.item_id
				slot.update_ui()


## -- signals --
func _on_slot_focused(focused_slot: UIActionBarSlot) -> void:
	focused_slot.set_focus(true)
	for slot: UIActionBarSlot in action_bar_slots:
		if slot.index != focused_slot.index:
			slot.set_focus(false)
	item_focused.emit(focused_slot.item_id)
	
func _on_ui_inventory_inventory_slot_updated(inv_slot: UIInventorySlot, inv_item: RInventoryItem) -> void:
	var matching_slot: UIActionBarSlot = _get_slot_by_index(inv_slot.index)
	if not matching_slot: return
	matching_slot.item_id = inv_item.item_id
	matching_slot.update_ui()
	_save_action_bar_slot_mappings()

func _on_ui_inventory_inventory_slot_depleted(inv_slot: UIInventorySlot) -> void:
	var matching_slot: UIActionBarSlot = _get_slot_by_index(inv_slot.index)
	if not matching_slot: return
	matching_slot.item_id = -1
	matching_slot.update_ui()
	_save_action_bar_slot_mappings()

func _on_equipped_item_manager_item_deselected() -> void:
	for slot: UIActionBarSlot in action_bar_slots:
		slot.set_focus(false)
