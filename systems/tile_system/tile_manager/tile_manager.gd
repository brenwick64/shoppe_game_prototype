class_name TileManager
extends Node

@export var tile_map: Node2D

var _tilemap_layers: Array[TileMapLayer]

func _ready() -> void:
	for node: Node in tile_map.get_children():
		if node is TileMapLayer:
			_tilemap_layers.append(node)
	_tilemap_layers.reverse() # we want end layers to be handled first

## -- methods --
func get_cust_meta_from_global_pos(global_position: Vector2, meta_key: String) -> String:
	for layer: TileMapLayer in _tilemap_layers:
		var tile_coords = _get_tile_from_global_pos(layer, global_position)
		var tile_data = layer.get_cell_tile_data(tile_coords)
		if not tile_data: continue # no tile in layer
		var meta: String = str(tile_data.get_custom_data(meta_key))
		if not meta: continue # no key in layer
		return meta
	return "none"

func get_terrain_type_from_global_pos(global_position: Vector2) -> String:
	for layer: TileMapLayer in _tilemap_layers:
		var tile_coords = _get_tile_from_global_pos(layer, global_position)
		var tile_data = layer.get_cell_tile_data(tile_coords)
		if not tile_data: continue
		var terrain_type: String = tile_data.get_custom_data("terrain_type")
		if not terrain_type: continue
		return terrain_type
	return "none"

## -- helper functions --
func _get_tile_from_global_pos(tilemap_layer: TileMapLayer, global_position: Vector2) -> Vector2i:
	var local_pos: Vector2 = tilemap_layer.to_local(global_position)
	var tile_coords: Vector2i = tilemap_layer.local_to_map(local_pos)
	return tile_coords

func _get_global_pos_from_tile(tilemap_layer: TileMapLayer, tile_coords: Vector2i) -> Vector2:
	var local_pos: Vector2 = tilemap_layer.map_to_local(tile_coords)
	var global_pos: Vector2 = tilemap_layer.to_global(local_pos)
	return global_pos
