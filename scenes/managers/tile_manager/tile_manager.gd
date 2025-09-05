class_name TileManager
extends Node

@export var tilemap_layer: TileMapLayer

func _get_tile_from_global_pos(global_position: Vector2) -> Vector2i:
	var local_pos: Vector2 = tilemap_layer.to_local(global_position)
	var tile_coords: Vector2i = tilemap_layer.local_to_map(local_pos)
	return tile_coords

func _get_global_pos_from_tile(tile_coords: Vector2i) -> Vector2:
	var local_pos: Vector2 = tilemap_layer.map_to_local(tile_coords)
	var global_pos: Vector2 = tilemap_layer.to_global(local_pos)
	return global_pos

func get_terrain_type_from_global_pos(global_position: Vector2) -> String:
	var tile_coords = _get_tile_from_global_pos(global_position)
	var tile_data = tilemap_layer.get_cell_tile_data(tile_coords)
	if not tile_data: return "none"
	var terrain_type: String = tile_data.get_custom_data("terrain_type")
	return terrain_type
