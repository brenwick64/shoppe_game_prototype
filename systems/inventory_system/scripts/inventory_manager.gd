class_name InventoryManager
extends Node

signal item_depleted(item_id: int)

@export var save_load_component: SaveLoadComponent

var inventory: Inventory
var inventory_ui: UIInventory

func _ready() -> void:
	var player_inv_ui: UIInventory = get_tree().get_first_node_in_group("ui_player_inventory")
	if not player_inv_ui: 
		push_error("InventoryManager error: no UI for player inventory found.")
	inventory_ui = player_inv_ui
	
	# load inventory (if applicable)
	var inventory_exists: bool = save_load_component.check_save_data()
	if not inventory_exists: _create_new_inventory()
	else: _load_inventory()
		
	# connect signals
	inventory.item_added.connect(_on_item_added)
	inventory.item_updated.connect(_on_item_updated)
	inventory.item_depleted.connect(_on_item_depleted)
	
	# allows UI nodes to build and connect signals first
	call_deferred("_update_inventory_ui")


## -- helper functions --
func _save_inventory():
	if not save_load_component: return
	save_load_component.save_data([inventory])

func _load_inventory():
	var loaded_data: Array = save_load_component.load_data()
	if not loaded_data:
		push_error("InventoryManager error: corrupted load file for inventory")
		_create_new_inventory()
		return
		
	inventory = loaded_data[0]

func _create_new_inventory():
	var new_inv: Inventory = Inventory.new()
	var new_inv_uuid: String = uuid.v4()
	new_inv.uuid = new_inv_uuid
	inventory = new_inv

func _update_inventory_ui() -> void:
	for inv_item: RInventoryItem in inventory.inventory_items:
		inventory_ui.handle_item_loaded(inv_item)


## -- signals --
func _on_item_added(new_item: RInventoryItem) -> void:
	inventory_ui.handle_item_added(new_item)
	_save_inventory()

func _on_item_updated(item: RInventoryItem) -> void:
	inventory_ui.handle_item_updated(item)
	_save_inventory()

func _on_item_depleted(item_id: int) -> void:
	item_depleted.emit(item_id)
	inventory_ui.handle_item_depleted(item_id)
	_save_inventory()
