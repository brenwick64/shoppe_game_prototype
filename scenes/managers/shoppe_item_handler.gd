class_name ShoppeItemHandler
extends ItemHandler

var shoppe_furniture: ShoppeFurniture

var _current_hovered_placeable_tile_coords: Variant
var _current_preview: PlaceablePreview


## -- public methods -- 
func handle_changed_tile() -> void:
	_clear_preview()
	if _current_hovered_placeable_tile_coords:
		var free_slots: Array[PlaceableItemSlot] = _get_free_slots()
		if not free_slots: return
		# TODO: organize slots
		print(free_slots)
		# spawn preview in slot
		_spawn_preview(free_slots[0])


## -- overrides --
func _ready() -> void:
	var shoppe_furniture_node: ShoppeFurniture = get_tree().get_first_node_in_group("shoppe_furniture")
	if not shoppe_furniture_node:
		push_error("PlaceableShoppeFurnitureHandler error: no shoppe_furniture node found.")
	shoppe_furniture = shoppe_furniture_node

func _physics_process(_delta: float) -> void:
	if not _current_item_data: return
	var placeable_tile: Variant = _get_placeable_tile()
	# detect change in tile hovered
	if _current_hovered_placeable_tile_coords != placeable_tile:
		_current_hovered_placeable_tile_coords = placeable_tile
		handle_changed_tile()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if not _current_preview: return
		_spawn_placeable()
		_clear_preview()
		_remove_item_from_inv()


## -- helper functions --
func _get_placeable_tile() -> Variant:
	var layer: TileMapLayer = GlobalTileManager.get_tilemap_layer_by_name("ShoppeFloor")
	if not layer: return null
	var mouse_gp: Vector2 = main_scene.get_global_mouse_position()
	var is_placeable: bool = GlobalTileManager.get_tile_custom_metadata(layer, mouse_gp, "is_placeable") == "true"
	if is_placeable:
		return GlobalTileManager.get_tile_from_global_position(layer, mouse_gp)
	return null

func _get_free_slots() -> Array[PlaceableItemSlot]:
	if not _current_hovered_placeable_tile_coords: return []
	var furniture: PlaceableFurniture = shoppe_furniture.get_furniture_at_coords(_current_hovered_placeable_tile_coords)
	if not furniture: return []
	var free_slots: Array[PlaceableItemSlot] = furniture.get_free_item_slots(_current_item_data.dimensions)
	return free_slots

func _spawn_preview(free_slot: PlaceableItemSlot) -> void:
	var preview_ins: PlaceableItemPreview = _current_item_data.new_preview()
	preview_ins.placeable_item_slot = free_slot
	if _current_preview:
		_current_preview.queue_free()
		_current_preview = null
	_current_preview = preview_ins
	free_slot.add_child(preview_ins)

func _clear_preview() -> void:
	if _current_preview:
		_current_preview.queue_free()
		_current_preview = null

func _spawn_placeable() -> void:
	if not _current_preview: return
	var placeable_ins: PlaceableItem = _current_item_data.new_placeable()
	_current_preview.placeable_item_slot.add_item(placeable_ins)

func _remove_item_from_inv() -> void:
	player_inventory_manager.inventory.remove_item(_current_item_data.item_id, 1)
