class_name RShoppeFurnitureSaveData
extends RSaveData

@export var furniture_unique_id: String
@export var item_id: int
@export var global_position: Vector2
@export var scale_value: Vector2
@export var dimensions: Vector2i
@export var origin_tile_coords: Vector2i
@export var occupied_tiles: Array[Vector2i]
@export var item_slot_item_ids: Array[int]


static func pack_save_data(placeable_node: PlaceableFurniture) -> RShoppeFurnitureSaveData:
	var save_data: RShoppeFurnitureSaveData = RShoppeFurnitureSaveData.new()
	save_data.furniture_unique_id = placeable_node.furniture_unique_id
	save_data.item_id = placeable_node.item_id
	save_data.global_position = placeable_node.global_position
	save_data.scale_value = placeable_node.scale
	save_data.dimensions = placeable_node.dimensions
	save_data.origin_tile_coords = placeable_node.origin_tile_coords
	save_data.occupied_tiles = placeable_node.occupied_tiles
	return save_data

static func unpack_save_data(save_data: RShoppeFurnitureSaveData) -> Node2D:
	var item_data: RShoppeFurnitureData = GlobalItemDb.get_item_by_id(save_data.item_id)
	var furniture_ins: PlaceableFurniture = item_data.new_placeable()
	furniture_ins.furniture_unique_id = save_data.furniture_unique_id
	furniture_ins.item_id = save_data.item_id
	furniture_ins.global_position = save_data.global_position
	furniture_ins.scale = save_data.scale_value
	furniture_ins.dimensions = save_data.dimensions
	furniture_ins.origin_tile_coords = save_data.origin_tile_coords
	furniture_ins.occupied_tiles = save_data.occupied_tiles
	return furniture_ins
