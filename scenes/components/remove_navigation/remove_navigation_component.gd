class_name RemoveNavigation
extends Node

@export var parent: Node2D
@export var tilemap_layer_name: String

func _ready() -> void:
	var layer: TileMapLayer = GlobalTileManager.get_tilemap_layer_by_name("Grass")
	var tile_coords: Vector2i = GlobalTileManager.get_tile_from_global_position(layer, parent.global_position)
	var tile_gp: Vector2 = GlobalTileManager.get_global_position_from_tile(layer, tile_coords)
	GlobalTileManager.navigation_blacklist_tile_gps.append(tile_gp)
	
	# update navigation
	#FIXME: very inefficient
	GlobalTileManager.update_layer_navigation(layer)
