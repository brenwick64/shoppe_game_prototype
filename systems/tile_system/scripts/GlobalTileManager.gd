## GlobalTileManager.gd
extends Node

var _tilemap_layers: Array[TileMapLayer]

## -- overrides --
func _ready() -> void:
	var tile_map: Node2D = get_tree().get_first_node_in_group("tile_map")
	if not tile_map:
		push_error("GlobalTileManager error: no tile map node found in tree.")
		return
	_load_tilemap_layers(tile_map)


## -- generic public methods --
func get_tilemap_layer_by_name(layer_name: String) -> TileMapLayer:
	for layer: TileMapLayer in _tilemap_layers:
		if layer.name == layer_name:
			return layer
	return null

func get_tilemap_layers_by_tag(tag: String) -> Array[TileMapLayer]:
	var matched_layers: Array[TileMapLayer] = []
	for layer: TileMapLayer in _tilemap_layers:
		if tag in layer.tags:
			matched_layers.append(layer)
	return matched_layers

func get_global_position_from_tile(layer: TileMapLayer, tile_coords: Vector2i) -> Vector2:
	var local_pos: Vector2 = layer.map_to_local(tile_coords)
	var global_pos: Vector2 = layer.to_global(local_pos)
	return global_pos
	
func get_tile_from_global_position(layer: TileMapLayer, global_position: Vector2) -> Vector2i:
	var local_pos: Vector2 = layer.to_local(global_position)
	var tile_coords: Vector2i = layer.local_to_map(local_pos)
	return tile_coords

func get_tile_custom_metadata(layer: TileMapLayer, global_position: Vector2, meta_key: String) -> String:
	var tile_coords: Vector2i = get_tile_from_global_position(layer, global_position)
	var tile_data: TileData = layer.get_cell_tile_data(tile_coords)
	if not tile_data: return ""
	var meta_string: String = str(tile_data.get_custom_data(meta_key))
	if not meta_string: return ""
	return meta_string


## -- custom public methods --
func update_layer_navigation(layer: TileMapLayer) -> void:
	layer.notify_runtime_tile_data_update()

func get_adjacent_ground_tiles_gp(global_position: Vector2, layer_name: String, filters: Array[String]) -> Array[Vector2]:
	var ground_layers: Array[TileMapLayer] = get_tilemap_layers_by_tag("ground")
	var tile_gps: Array[Vector2] = []
	for layer: TileMapLayer in ground_layers:
		if layer.name != layer_name: continue
		var primary_tile_coords: Vector2 = get_tile_from_global_position(layer, global_position)
		var adjacent_tiles: Array[Vector2i] = layer.get_surrounding_cells(primary_tile_coords)
		if "navigatable" in filters:
			adjacent_tiles = adjacent_tiles.filter(func(coords: Vector2i): return _is_tile_naviagatable(layer, coords))
		if "unobstructed" in filters:
			adjacent_tiles = adjacent_tiles.filter(func(coords: Vector2i): return not _is_tile_obstructed(layer, coords))
		for tile_coords: Vector2i in adjacent_tiles:
			tile_gps.append(get_global_position_from_tile(layer, tile_coords))

	return tile_gps

# checks to see if multiple navigation layers are trying to populate the same tile
# us this with the TileMapLayer's _use_tile_data_runtime_update override
func is_navigation_tile_collision(main_layer: TileMapLayer, coords: Vector2i) -> bool:
	var nav_layers: Array[TileMapLayer] = get_tilemap_layers_by_tag("navigatable")
	var tile_gp: Vector2 = get_global_position_from_tile(main_layer, coords)
	for layer: TileMapLayer in nav_layers:
		if layer == main_layer: continue # cant collide with itself.
		var layer_coords: Vector2i = GlobalTileManager.get_tile_from_global_position(layer, tile_gp)
		var source_id: int = layer.get_cell_source_id(layer_coords)
		if source_id != -1: # there is a collision
			return true
	return false # no collision

func is_obstructable_tile_collision(main_layer: TileMapLayer, coords: Vector2i) -> bool:
	var obstructable_layers: Array[TileMapLayer] = get_tilemap_layers_by_tag("obstructable")
	var tile_gp: Vector2 = get_global_position_from_tile(main_layer, coords)
	for layer: TileMapLayer in obstructable_layers:
		if layer == main_layer: continue # cant collide with itself.
		var layer_coords: Vector2i = GlobalTileManager.get_tile_from_global_position(layer, tile_gp)
		var source_id: int = layer.get_cell_source_id(layer_coords)
		if source_id != -1: # there is a collision
			return true
	return false # no collision

## -- helper functions --
func _load_tilemap_layers(tile_map: Node2D) -> void:
	for node: Node in tile_map.get_children():
		if node is not TileMapLayer: continue
		_tilemap_layers.append(node)

func _is_tile_naviagatable(layer: TileMapLayer, tile_coords: Vector2i) -> bool:
	var tile_gp: Vector2 = get_global_position_from_tile(layer, tile_coords)
	var tile_data: TileData = layer.get_cell_tile_data(tile_coords)
	if not tile_data: return false # not in navigatable layer
	var naviagtion: NavigationPolygon = tile_data.get_navigation_polygon(0)
	if not naviagtion: return false # not configured for navigation
	return true

func _is_tile_obstructed(primary_layer: TileMapLayer, tile_coords: Vector2i) -> bool:
	var obstructable_layers: Array[TileMapLayer] = get_tilemap_layers_by_tag("obstructable")
	var tile_gp: Vector2 = get_global_position_from_tile(primary_layer, tile_coords)
	for layer: TileMapLayer in obstructable_layers:
		var layer_coords: Vector2i = get_tile_from_global_position(layer, tile_gp)
		var source_id: int = layer.get_cell_source_id(layer_coords)
		if source_id != -1: return true # obstructable tile found
	return false
