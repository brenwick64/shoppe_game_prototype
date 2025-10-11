class_name RInventorySaveData
extends RSaveData

@export var uuid: String
@export var inventory_items: Array[RInventoryItem]

static func pack_save_data(inventory: Inventory) -> RInventorySaveData:
	var save_data: RInventorySaveData = RInventorySaveData.new()
	save_data.uuid = inventory.uuid
	save_data.inventory_items = inventory.inventory_items
	return save_data

static func unpack_save_data(save_data: RInventorySaveData) -> Inventory:
	var inventory: Inventory = Inventory.new()
	inventory.uuid = save_data.uuid
	inventory.inventory_items = save_data.inventory_items
	return inventory
