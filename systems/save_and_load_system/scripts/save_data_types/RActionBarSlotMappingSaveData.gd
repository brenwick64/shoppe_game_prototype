class_name RActionBarSlotMappingSaveData
extends RSaveData

@export var index: int
@export var item_id: int

static func pack_save_data(slot: UIActionBarSlot) -> RActionBarSlotMappingSaveData:
	var save_data: RActionBarSlotMappingSaveData = RActionBarSlotMappingSaveData.new()
	save_data.index = slot.index
	save_data.item_id = slot.item_id
	return save_data

static func unpack_save_data(save_data: RActionBarSlotMappingSaveData) -> RActionBarSlotMappingSaveData:
	return save_data
