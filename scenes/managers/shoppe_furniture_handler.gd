class_name ShoppeFurnitureHandler
extends ItemHandler

var shoppe_furniture: ShoppeFurniture

var _current_hovered_placeable_tile_coords: Variant
var _current_preview: PlaceablePreview

## -- public methods --
func clear_item() -> void:
	super.clear_item()
	_clear_preview()

func handle_changed_tile() -> void:
	_clear_preview()
	if _current_hovered_placeable_tile_coords:
		_spawn_preview()
		_set_is_placeable(_current_hovered_placeable_tile_coords, _current_preview.dimensions)


## -- overrides --
func _ready() -> void:
	var shoppe_furniture_node: ShoppeFurniture = get_tree().get_first_node_in_group("shoppe_furniture")
	if not shoppe_furniture_node:
		push_error("PlaceableShoppeFurnitureHandler error: no shoppe_furniture node found.")
	shoppe_furniture = shoppe_furniture_node

# performs basic checks and spawns in item preview
func _physics_process(_delta: float) -> void:
	if not main_scene: return
	if not _current_item_data: return
	var placeable_tile: Variant = _get_placeable_tile()
	# detect change in tile hovered
	if _current_hovered_placeable_tile_coords != placeable_tile:
		_current_hovered_placeable_tile_coords = placeable_tile
		handle_changed_tile()

# performs more advanced checks and spawns in placeable item
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if not _current_preview: return
		if _current_preview.is_placement_blocked(): return
		if shoppe_furniture.check_placeable_collision(_current_hovered_placeable_tile_coords, _current_preview.dimensions): return
		
		_spawn_placeable()
		_clear_preview()
		_remove_item_from_inv()


### -- helper functions --
func _get_placeable_tile() -> Variant:
	var layer: TileMapLayer = GlobalTileManager.get_tilemap_layer_by_name("ShoppeFloor")
	if not layer: return null
	var mouse_gp: Vector2 = main_scene.get_global_mouse_position()
	var is_placeable: bool = GlobalTileManager.get_tile_custom_metadata(layer, mouse_gp, "is_placeable") == "true"
	if is_placeable:
		return GlobalTileManager.get_tile_from_global_position(layer, mouse_gp)
	return null

func _spawn_preview() -> void:
	var layer: TileMapLayer = GlobalTileManager.get_tilemap_layer_by_name("ShoppeFloor")
	if not layer: return
	var tile_gp: Vector2 = GlobalTileManager.get_global_position_from_tile(layer, _current_hovered_placeable_tile_coords)
	# create preview scene
	var preview_scene: Node2D = _current_item_data.new_preview()
	preview_scene.global_position = tile_gp - preview_scene.placement_pivot.global_position
	_current_preview = preview_scene
	main_scene.add_child(preview_scene)

func _set_is_placeable(origin_tile_coords: Vector2i, dimensions: Vector2i) -> void:
	var is_placeable: bool = true
	var layer: TileMapLayer = GlobalTileManager.get_tilemap_layer_by_name("ShoppeFloor")
	if not layer: return 
	var xform_matrix: Array[Vector2i] = Utils.create_transformation_matrix(dimensions)
	for vector: Vector2i in xform_matrix:
		var tile_to_check: Vector2i = origin_tile_coords + vector
		var gp: Vector2 = GlobalTileManager.get_global_position_from_tile(layer, tile_to_check)
		var tile_placeable: bool = GlobalTileManager.get_tile_custom_metadata(layer, gp, "is_placeable") == "true"
		if not tile_placeable:
			is_placeable = false
	_current_preview.set_is_placeable(is_placeable)

func _clear_preview() -> void:
	if _current_preview:
		_current_preview.queue_free()
		_current_preview = null

func _spawn_placeable() -> void:
	if not _current_preview: return
	var placeable_ins: Node2D = _current_item_data.new_placeable()
	var global_pos: Vector2 = _current_preview.global_position
	placeable_ins.global_position = global_pos
	placeable_ins.origin_tile_coords = _current_hovered_placeable_tile_coords
	shoppe_furniture.add_placeable_furniture(placeable_ins)

func _remove_item_from_inv() -> void:
	player_inventory_manager.inventory.remove_item(_current_item_data.item_id, 1)
