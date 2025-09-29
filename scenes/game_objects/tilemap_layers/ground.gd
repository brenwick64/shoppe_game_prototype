class_name NavigatableLayer
extends GenericLayer

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	var is_collision: bool = false
	is_collision = GlobalTileManager.is_navigation_tile_collision(self, coords)
	if is_collision: return true
	is_collision = GlobalTileManager.is_obstructable_tile_collision(self, coords)
	return is_collision

func _tile_data_runtime_update(_coords: Vector2i, tile_data: TileData) -> void:
	tile_data.set_navigation_polygon(0, null)
