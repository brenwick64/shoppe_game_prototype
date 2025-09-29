class_name RPlaceableItemSaveData
extends RSaveData

@export var global_pos: Vector2
@export var scale_value: Vector2
@export var item_data: RItemData

static func pack_save_data(placeable_node: Node2D) -> RPlaceableItemSaveData:
	var save_data: RPlaceableItemSaveData = RPlaceableItemSaveData.new()
	save_data.global_pos = placeable_node.global_position
	save_data.scale_value = placeable_node.scale
	#save_data.item_data = placeable_node
	return save_data

static func unpack_save_data(save_data: RInventorySlotMappingSaveData) -> RInventorySlotMappingSaveData:
	return save_data
