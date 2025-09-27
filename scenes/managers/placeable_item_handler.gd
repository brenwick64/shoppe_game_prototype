class_name PlaceableItemHandler
extends ItemHandler

var _current_hovered_tile_coords: Variant
var _current_preview: Node2D

## -- public methods --
func clear_item() -> void:
	super.clear_item()
	_clear_preview()


## -- helper functions --
func _get_placeable_tile() -> Variant:
	var mouse_gp: Vector2 = main_scene.get_global_mouse_position()
	var coords = GlobalTileManager.get_placeable_tile_from_gp(mouse_gp)
	return coords

func _handle_changed_tile() -> void:
	_clear_preview()
	if _current_hovered_tile_coords:
		_spawn_preview()

func _spawn_preview() -> void:
	var tile_gp: Vector2 = GlobalTileManager.get_tile_gp_shoppe_floor(_current_hovered_tile_coords)
	var preview_scene: Node2D = _current_item_data.new_preview(tile_gp)
	_current_preview = preview_scene
	main_scene.add_child(preview_scene)

func _clear_preview() -> void:
	if _current_preview:
		_current_preview.queue_free()
		_current_preview = null

func _spawn_placeable() -> void:
	if not _current_preview: return
	var global_pos: Vector2 = _current_preview.global_position
	var placeable_ins: Node2D = _current_item_data.new_placeable(global_pos)
	main_scene.add_child(placeable_ins)
	_clear_preview()
	_remove_item_from_inv()

func _remove_item_from_inv() -> void:
	player_inventory_manager.inventory.remove_item(_current_item_data.item_id, 1)


## -- overrides --
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if not _current_preview: return
		if _current_preview.is_placement_blocked(): return
		_spawn_placeable()

func _physics_process(_delta: float) -> void:
	if not main_scene: return
	if not _current_item_data: return
	var placeable_tile: Variant = _get_placeable_tile()
	# detect change in tile hovered
	if _current_hovered_tile_coords != placeable_tile:
		_current_hovered_tile_coords = placeable_tile
		_handle_changed_tile()
