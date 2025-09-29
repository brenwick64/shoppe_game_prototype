class_name ShoppeFurniture
extends Node2D

var shoppe_furniture: Array[Placeable] = []
var occupied_tiles: Array[Vector2i]

## -- public methods --
func get_occupied_tiles() -> Array[Vector2i]:
	return occupied_tiles

func add_placeable_furniture(placeable_furniture: Placeable) -> void:
	var new_occupied_tiles: Array[Vector2i] = _get_furniture_occupied_tiles(placeable_furniture.origin_tile_coords, placeable_furniture.dimensions)
	_add_occupied_tiles(new_occupied_tiles)
	_update_layer_navigation()
	add_child(placeable_furniture)

func remove_placeable_furniture(placeable_furniture: Placeable) -> void:
	_remove_occupied_tiles(placeable_furniture.origin_tile_coords, placeable_furniture.dimensions)
	_update_layer_navigation()
	placeable_furniture.queue_free()

func check_placeable_collision(tile_origin: Vector2i, furniture_dimensions: Vector2i) -> bool:
	var furniture_occupied_tiles: Array[Vector2i] =_get_furniture_occupied_tiles(tile_origin, furniture_dimensions)
	for tile: Vector2i in furniture_occupied_tiles:
		if tile in occupied_tiles:
			return true
	return false


## -- helper functions --
func _add_occupied_tiles(new_occupied_tiles: Array[Vector2i]) -> void:
	occupied_tiles += new_occupied_tiles
	
# TODO:
func _remove_occupied_tiles(tile_origin: Vector2i, furniture_dimensions: Vector2i) -> void:
	pass

func _update_layer_navigation():
	var layer: TileMapLayer = GlobalTileManager.get_tilemap_layer_by_name("ShoppeFloor")
	if layer: GlobalTileManager.update_layer_navigation(layer)

func _get_furniture_occupied_tiles(tile_origin: Vector2i, furniture_dimensions: Vector2i) -> Array[Vector2i]:
	var furniture_occupied_tiles: Array[Vector2i] = []
	var transformation_matrix: Array[Vector2i] = Utils.create_transformation_matrix(furniture_dimensions)
	for element: Vector2i in transformation_matrix:
		furniture_occupied_tiles.append(tile_origin + element)
	return furniture_occupied_tiles

# TODO:
## -- save / load --
