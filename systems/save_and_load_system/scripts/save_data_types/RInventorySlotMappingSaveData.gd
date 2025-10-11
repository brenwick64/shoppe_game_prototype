class_name RInventorySlotMappingSaveData
extends RSaveData

@export var index: int
@export var item_id: int

static func pack_save_data(slot: UIInventorySlot) -> RInventorySlotMappingSaveData:
	var save_data: RInventorySlotMappingSaveData = RInventorySlotMappingSaveData.new()
	save_data.index = slot.index
	save_data.item_id = slot.item_id
	return save_data

static func unpack_save_data(save_data: RInventorySlotMappingSaveData) -> RInventorySlotMappingSaveData:
	return save_data
