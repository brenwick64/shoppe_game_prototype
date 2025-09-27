class_name NavigatableLayer
extends GenericLayer

@export var intersecting_layers: Array[TileMapLayer]

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	var tile_gp: Vector2 = GlobalTileManager.get_global_pos_from_tile(self, coords)
	for layer: TileMapLayer in intersecting_layers:
		var layer_coords: Vector2i = GlobalTileManager.get_tile_from_global_pos(layer, tile_gp)
		var source_id: int = layer.get_cell_source_id(layer_coords)
		if source_id != -1: # there is a collision
			return true
	return false # no collision

func _tile_data_runtime_update(_coords: Vector2i, tile_data: TileData) -> void:
	tile_data.set_navigation_polygon(0, null)
