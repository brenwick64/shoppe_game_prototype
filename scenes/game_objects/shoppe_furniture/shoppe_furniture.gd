class_name ShoppeFurniture
extends Node2D

signal furniture_updated(shoppe_furniture: Array[Placeable])

@onready var save_load_component: SaveLoadComponent = $SaveLoadComponent

var shoppe_furniture: Array[PlaceableFurniture] = []
var occupied_tiles: Array[Vector2i]

func _ready() -> void:
	if save_load_component.check_save_data():
		_load_furniture()

## -- public methods --
func get_furniture_by_unique_id(unique_id: String) -> PlaceableFurniture:
	for furniture: PlaceableFurniture in shoppe_furniture:
		if furniture.furniture_unique_id == unique_id:
			return furniture
	return null

func get_furniture_at_coords(tile_coords: Vector2i) -> PlaceableFurniture:
	for furniture: PlaceableFurniture in shoppe_furniture:
		if tile_coords in furniture.occupied_tiles:
			return furniture
	return null

func get_occupied_tiles() -> Array[Vector2i]:
	return occupied_tiles

func add_placeable_furniture(placeable_furniture: PlaceableFurniture) -> void:
	var new_occupied_tiles: Array[Vector2i] = _get_furniture_occupied_tiles(placeable_furniture.origin_tile_coords, placeable_furniture.dimensions)
	placeable_furniture.occupied_tiles = new_occupied_tiles
	shoppe_furniture.append(placeable_furniture)
	add_child(placeable_furniture)
	_add_occupied_tiles(placeable_furniture.occupied_tiles)
	_update_layer_navigation()
	_save_furniture()

func remove_placeable_furniture(placeable_furniture: PlaceableFurniture) -> void:
	var tiles_to_remove: Array[Vector2i] = _get_furniture_occupied_tiles(placeable_furniture.origin_tile_coords, placeable_furniture.dimensions)
	_remove_occupied_tiles(tiles_to_remove)
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
func _remove_occupied_tiles(tiles_to_remove: Array[Vector2i]) -> void:
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


## -- save / load --
func _save_furniture() -> void:
	save_load_component.save_data(shoppe_furniture)

func _load_furniture() -> void:
	var loaded_data: Array = save_load_component.load_data()
	for node: Node in loaded_data:
		if node is Placeable:
			node.is_loaded_in = true
			add_placeable_furniture(node)
