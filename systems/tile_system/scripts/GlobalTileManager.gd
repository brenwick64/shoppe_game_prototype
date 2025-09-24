## GlobalTileManager.gd
extends Node

var _tilemap_layers: Array[TileMapLayer]
var _navigatable_layer: TileMapLayer

func _ready() -> void:
	var tile_map: Node2D = get_tree().get_first_node_in_group("tile_map")
	if not tile_map:
		push_error("GlobalTileManager error: no tile map node found in tree.")
		return
	_load_tilemap_layers(tile_map)
	_load_navigatable_layer(tile_map)


## -- public methods --
func get_tile_from_global_pos(tilemap_layer: TileMapLayer, global_position: Vector2) -> Vector2i:
	var local_pos: Vector2 = tilemap_layer.to_local(global_position)
	var tile_coords: Vector2i = tilemap_layer.local_to_map(local_pos)
	return tile_coords

func get_global_pos_from_tile(tilemap_layer: TileMapLayer, tile_coords: Vector2i) -> Vector2:
	var local_pos: Vector2 = tilemap_layer.map_to_local(tile_coords)
	var global_pos: Vector2 = tilemap_layer.to_global(local_pos)
	return global_pos

func get_nearby_navigatable_tile_positions_from_gp(global_position: Vector2) -> Array[Vector2]:
	var navigatable_tile_gps: Array[Vector2] = []
	if not _navigatable_layer: return []

	var tile_coords: Vector2i = get_tile_from_global_pos(_navigatable_layer, global_position)
	var surrounding_tiles: Array[Vector2i] = _navigatable_layer.get_surrounding_cells(tile_coords)
	for tile: Vector2i in surrounding_tiles:
		if _is_tile_naviagatable(tile):
			var tile_gp: Vector2 = get_global_pos_from_tile(_navigatable_layer, tile)
			navigatable_tile_gps.append(tile_gp)
	return navigatable_tile_gps

func get_cust_meta_from_global_pos(global_position: Vector2, meta_key: String) -> String:
	for layer: TileMapLayer in _tilemap_layers:
		var tile_coords = get_tile_from_global_pos(layer, global_position)
		var tile_data = layer.get_cell_tile_data(tile_coords)
		if not tile_data: continue # no tile in layer
		var meta: String = str(tile_data.get_custom_data(meta_key))
		if not meta: continue # no key in layer
		return meta
	return "none"


## -- helper functions --
func _load_tilemap_layers(tile_map: Node2D) -> void:
	for node: Node in tile_map.get_children():
		if node is TileMapLayer:
			_tilemap_layers.append(node)
	_tilemap_layers.reverse() # we want end layers to be handled first

func _load_navigatable_layer(tile_map: Node2D) -> void:
	for node: Node in tile_map.get_children():
		if node is NavigatableLayer:
			_navigatable_layer = node
	if not _navigatable_layer:
		push_error("GlobalTileManager error: no NavigatableLayer found in TileMap.")

func _is_tile_naviagatable(tile_coords: Vector2i) -> bool:
	var tile_data: TileData = _navigatable_layer.get_cell_tile_data(tile_coords)
	if not tile_data: return false # not in navigatable layer
	var naviagtion: NavigationPolygon = tile_data.get_navigation_polygon(0)
	if not naviagtion: # not configured for navigation
		return false
	return true # in layer AND navigatable
