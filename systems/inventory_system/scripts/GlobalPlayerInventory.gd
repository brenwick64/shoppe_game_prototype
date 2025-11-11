# GlobalPlayerInventory.gd
extends Node

signal item_aquired(item_id: int, count: int)
signal item_added(inv_item: RInventoryItem)
signal item_updated(inv_item: RInventoryItem)
signal item_depleted(item_id: int)

@onready var save_load_component_scene: PackedScene = preload("res://systems/save_and_load_system/scenes/save_load_component.tscn")

const SAVE_FILENAME: String = "player_inventory"
var SAVE_DATA_TYPE: RInventorySaveData = RInventorySaveData.new()

var inventory: Inventory
var save_load_component: SaveLoadComponent

func _ready() -> void:
	save_load_component = _create_save_load_component()

	# load inventory (if applicable)
	var inventory_exists: bool = save_load_component.check_save_data()
	if inventory_exists: _load_inventory()
	else: _create_new_inventory()

	## connect signals
	inventory.item_added.connect(_on_item_added)
	inventory.item_updated.connect(_on_item_updated)
	inventory.item_depleted.connect(_on_item_depleted)
	inventory.item_aquired.connect(_on_item_aquired)


## -- public methods --
# GET
func get_items() -> Array[RInventoryItem]:
	return inventory.get_inventory()
	
func get_item(item_id: int) -> RInventoryItem:
	return inventory.get_inventory_item(item_id)

# HAS
func has_item_id(item_id: int) -> bool:
	return inventory.has_item_id(item_id)

func has_items(items: Array[RInventoryItem]) -> bool:
	return inventory.has_items(items)

# ADD
func add_item(item_id: int, count: int) -> void:
	inventory.add_item(item_id, count)

func add_items(inv_items: Array[RInventoryItem]) -> void:
	inventory.add_items(inv_items)

# DELETE
func remove_item(item_id: int, count: int) -> void:
	inventory.remove_item(item_id, count)

func remove_items(inv_items: Array[RInventoryItem]) -> void:
	inventory.remove_items(inv_items)


## -- helper functions --
func _create_save_load_component() -> SaveLoadComponent:
	var new_save_load_component: SaveLoadComponent = save_load_component_scene.instantiate()
	new_save_load_component.save_filename = SAVE_FILENAME
	new_save_load_component.save_data_type = SAVE_DATA_TYPE
	add_child(new_save_load_component)
	return new_save_load_component

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


## -- signals --
func _on_item_added(new_item: RInventoryItem) -> void:
	item_added.emit(new_item)
	_save_inventory()

func _on_item_updated(item: RInventoryItem) -> void:
	item_updated.emit(item)
	_save_inventory()

func _on_item_depleted(item_id: int) -> void:
	item_depleted.emit(item_id)
	_save_inventory()

func _on_item_aquired(item_id: int, count: int) -> void:
	item_aquired.emit(item_id, count)
