class_name RShoppeItemSaveData
extends RSaveData

@export var item_id: int
@export var furniture_unique_id: String
@export var item_slot_index: int
@export var scale: Vector2

static func pack_save_data(placeable_item: PlaceableItem) -> RShoppeItemSaveData:
	var save_data: RShoppeItemSaveData = RShoppeItemSaveData.new()
	save_data.item_id = placeable_item.item_id
	save_data.scale = placeable_item.scale
	save_data.item_slot_index = placeable_item.item_slot_index
	save_data.furniture_unique_id = placeable_item.furniture_unique_id
	return save_data

static func unpack_save_data(save_data: RShoppeItemSaveData) -> PlaceableItem:
	var item_data: RShoppeItemData = GlobalItemDb.get_item_by_id(save_data.item_id)
	var placeable_ins: PlaceableItem = item_data.new_placeable()
	placeable_ins.item_id = save_data.item_id
	placeable_ins.scale = save_data.scale
	placeable_ins.item_slot_index = save_data.item_slot_index
	placeable_ins.furniture_unique_id = save_data.furniture_unique_id
	return placeable_ins
