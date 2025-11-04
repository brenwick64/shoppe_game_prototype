class_name UIInventory
extends Control

signal inventory_slot_updated(inv_slot: UIInventorySlot, inv_item: RInventoryItem)
signal inventory_slot_depleted(inv_slot: UIInventorySlot)

@onready var grid_container: GridContainer = $MainPanel/VBoxContainer/GridContainer
@onready var save_load_component: SaveLoadComponent = $SaveLoadComponent

var inventory_slots: Array[UIInventorySlot]

## -- overrides --
func _ready() -> void:
	# connect player inventory signals
	GlobalPlayerInventory.item_added.connect(_on_item_added)
	GlobalPlayerInventory.item_updated.connect(_on_item_updated)
	GlobalPlayerInventory.item_depleted.connect(_on_item_depleted)
	# connect mapping container signals
	for node: Node in grid_container.get_children():
		if node is not UIInventorySlot: continue
		node.slot_hovered.connect(_on_slot_hovered)
		node.slot_updated.connect(_on_slot_updated)
		node.slot_depleted.connect(_on_slot_depleted)
		node.slot_dropped.connect(_on_slot_dropped)
		inventory_slots.append(node)
	# load inventory mapping data
	var mappings_exist: bool = save_load_component.check_save_data() 
	if mappings_exist:
		var mappings: Array = save_load_component.load_data()
		_load_inv_slot_mappings(mappings)
	# load_inventory_data
	for inv_item in GlobalPlayerInventory.get_items():
		handle_item_loaded(inv_item)
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		_toggle_visible()


## -- public handlers --
func handle_item_loaded(loaded_item: RInventoryItem) -> void:
	var slot_to_load: UIInventorySlot = _get_inv_slot_by_id(loaded_item.item_id)
	if not slot_to_load:
		push_error("UIInventory error. attempted to load item with no reserved inv slot.") 
		return
	slot_to_load.add_item(loaded_item)
	inventory_slot_updated.emit(slot_to_load, loaded_item)

#func handle_item_added(new_item: RInventoryItem) -> void:
	#var free_slot: UIInventorySlot = _get_inv_slot_by_id(-1)
	#if not free_slot:
		#push_warning("UIInventory failed to add item. no free slot available.") 
		#return
	#free_slot.add_item(new_item)
	#inventory_slot_updated.emit(free_slot, new_item)
	#_save_inv_slot_mappings()
#
#func handle_item_updated(item: RInventoryItem) -> void:
	#var slot_to_update: UIInventorySlot = _get_inv_slot_by_id(item.item_id)
	#if not slot_to_update:
		#push_warning("UIInventory failed to update item. item slot not found.") 
		#return
	#slot_to_update.update_item_count(item.count)
	#inventory_slot_updated.emit(slot_to_update, item)
#
#func handle_item_depleted(item_id: int) -> void:
	#var slot_to_deplete: UIInventorySlot = _get_inv_slot_by_id(item_id)
	#if not slot_to_deplete:
		#push_warning("UIInventory failed to deplete item. item slot not found.") 
		#return
	#slot_to_deplete.clear_item()
	#inventory_slot_depleted.emit(slot_to_deplete)
	#_save_inv_slot_mappings()


## -- save / load --
func _save_inv_slot_mappings() -> void:
	save_load_component.save_data(inventory_slots)

func _load_inv_slot_mappings(mappings: Array) -> void:
	for mapping in mappings:
		# item no longer exists
		if not GlobalPlayerInventory.has_item_id(mapping.item_id):
			mapping.item_id = -1
		# slot already defaults to this value
		if mapping.item_id == -1: continue
		for slot: UIInventorySlot in inventory_slots:
			if mapping.index == slot.index:
				slot.item_id = mapping.item_id


## -- helper functions --
func _get_inv_slot_by_id(item_id: int) -> UIInventorySlot:
	for slot: UIInventorySlot in inventory_slots:
		if slot.item_id == item_id:
			return slot
	return null

func _toggle_visible() -> void:
	self.visible = not self.visible


## -- signals --
# ITEM
func _on_item_added(inv_item: RInventoryItem) -> void:
	pass

func _on_item_updated(inv_item: RInventoryItem) -> void:
	pass

func _on_item_depleted(item_id: int) -> void:
	pass

# SLOTS
func _on_slot_updated(inv_slot: UIInventorySlot, inv_item: RInventoryItem) -> void:
	inventory_slot_updated.emit(inv_slot, inv_item)
	_save_inv_slot_mappings()

func _on_slot_depleted(inv_slot: UIInventorySlot) -> void:
	inventory_slot_depleted.emit(inv_slot)
	_save_inv_slot_mappings()

func _on_slot_hovered(inv_slot: UIInventorySlot) -> void:
	for slot: UIInventorySlot in inventory_slots:
		if slot == inv_slot: slot.set_focus(true)
		else: slot.set_focus(false)

func _on_slot_dropped() -> void:
	for slot: UIInventorySlot in inventory_slots:
		slot.set_focus(false)
