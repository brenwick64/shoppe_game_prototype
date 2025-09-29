class_name PlaceableItems
extends Node2D

var placeable_items: Array[Placeable] = []
var occupied_tiles: Array[Vector2i]

## -- public methods --
func get_placeable_item_tiles(placeable_item: Placeable) -> Array[Vector2i]:
	return []

func add_placeable_item(placeable_item: Placeable) -> void:
	_add_occupied_tiles(placeable_item.origin_tile_coords, placeable_item.dimensions)
	add_child(placeable_item)

func remove_placeable_item(placeable_item: Placeable) -> void:
	_remove_occupied_tiles(placeable_item.origin_tile_coords, placeable_item.dimensions)
	placeable_item.queue_free()

func check_collision(tile_origin: Vector2i, item_dimensions: Vector2i) -> bool:
	var item_occupied_tiles: Array[Vector2i] =_get_item_occupied_tiles(tile_origin, item_dimensions)
	for tile: Vector2i in item_occupied_tiles:
		if tile in occupied_tiles:
			return true
	return false


## -- helper functions --
func _add_occupied_tiles(tile_origin: Vector2i, item_dimensions: Vector2i) -> void:
	var item_occupied_tiles: Array[Vector2i] =_get_item_occupied_tiles(tile_origin, item_dimensions)
	occupied_tiles += item_occupied_tiles
	
func _remove_occupied_tiles(tile_origin: Vector2i, item_dimensions: Vector2i) -> void:
	var item_occupied_tiles: Array[Vector2i] =_get_item_occupied_tiles(tile_origin, item_dimensions)
	occupied_tiles.filter(
		func(tile: Vector2i): return tile not in item_occupied_tiles
	)

func _create_transformation_matrix(item_dimensions: Vector2i)  -> Array[Vector2i]:
	var transformation_matrix: Array[Vector2i] = [Vector2i(0, 0)]
	for i: int in range(item_dimensions.x - 1):
		transformation_matrix.append(Vector2i(i + 1,0))
	for j: int in range(item_dimensions.y - 1):
		transformation_matrix.append(Vector2i(0, j + 1))
	return transformation_matrix

func _get_item_occupied_tiles(tile_origin: Vector2i, item_dimensions: Vector2i) -> Array[Vector2i]:
	var item_occupied_tiles: Array[Vector2i] = []
	var transformation_matrix: Array[Vector2i] = _create_transformation_matrix(item_dimensions)
	for element: Vector2i in transformation_matrix:
		item_occupied_tiles.append(tile_origin + element)
	return item_occupied_tiles

# TODO:
## -- save / load --
