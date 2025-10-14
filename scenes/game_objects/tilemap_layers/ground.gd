class_name NavigatableLayer
extends GenericLayer

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	var is_nav_collision: bool = GlobalTileManager.is_navigation_tile_collision(self, coords)
	if is_nav_collision: return true
	var is_obs_collision: bool = GlobalTileManager.is_obstructable_tile_collision(self, coords)
	if is_obs_collision: return true
	var is_blacklisted: bool = GlobalTileManager.is_blacklisted_from_navigation(self, coords)
	if is_blacklisted: return true
	return false

func _tile_data_runtime_update(_coords: Vector2i, tile_data: TileData) -> void:
	tile_data.set_navigation_polygon(0, null)
