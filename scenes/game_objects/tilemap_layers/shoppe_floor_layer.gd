class_name ShoppeFloorLayer
extends GenericLayer

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	var shoppe_furniture: ShoppeFurniture = get_tree().get_first_node_in_group("shoppe_furniture")
	if shoppe_furniture:
		if coords in shoppe_furniture.get_occupied_tiles(): return true
	if GlobalTileManager.is_obstructable_tile_collision(self, coords):
		return true
	return false

func _tile_data_runtime_update(_coords: Vector2i, tile_data: TileData) -> void:
	tile_data.set_navigation_polygon(0, null)
