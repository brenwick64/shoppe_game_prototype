class_name ShoppeRemoverHandler
extends ItemHandler

var shoppe_floor_layer: TileMapLayer
var shoppe_furniture_ref: ShoppeFurniture

var _current_hovered_shope_tile: Vector2i
var _current_placeable_to_delete: Placeable

## -- overrides --
func _ready() -> void:
	var shoppe_floor: TileMapLayer = GlobalTileManager.get_tilemap_layer_by_name("ShoppeFloor")
	if not shoppe_floor:
		push_error("ShoppeRemoverHandler error: no shoppe floor layer found.")
		return
	shoppe_floor_layer = shoppe_floor
	var shoppe_furniture: ShoppeFurniture = get_tree().get_first_node_in_group("shoppe_furniture")
	if not shoppe_furniture:
		push_error("ShoppeRemoverHandler error: no shoppe_furniture node found.")
		return
	shoppe_furniture_ref = shoppe_furniture

func _physics_process(_delta: float) -> void:
	if not _current_item_data: return
	if not shoppe_floor_layer: return
	var hovered_shoppe_tile: Variant = _get_shoppe_tile()
	# detect change in tile hovered
	if _current_hovered_shope_tile != hovered_shoppe_tile:
		_current_hovered_shope_tile = hovered_shoppe_tile
		# handle hovered tile change
		var placeable_to_delete: Placeable = _get_hovered_item_to_delete()
		if _current_placeable_to_delete and _current_placeable_to_delete != placeable_to_delete:
			_current_placeable_to_delete.hide_outline()
		if placeable_to_delete:
			placeable_to_delete.show_outline()
		_current_placeable_to_delete = placeable_to_delete


## -- helper functions --
func _get_shoppe_tile() -> Vector2i:
	var mouse_gp: Vector2 = main_scene.get_global_mouse_position()
	var hovered_tile: Vector2i = GlobalTileManager.get_tile_from_global_position(shoppe_floor_layer, mouse_gp)
	return hovered_tile

func _get_furniture_at_hovered_tile() -> PlaceableFurniture:
	var furniture: PlaceableFurniture = shoppe_furniture_ref.get_furniture_at_coords(_current_hovered_shope_tile)
	return furniture

func _get_hovered_item_at_furniture(furniture: PlaceableFurniture) -> PlaceableItem:
	var full_item_slots: Array[PlaceableItemSlot] = furniture.get_full_item_slots()
	if not full_item_slots: return
	for slot: PlaceableItemSlot in full_item_slots:
		if _current_hovered_shope_tile in slot.placed_item_tile_coords:
			return slot.placed_item
	return null

func _get_hovered_item_to_delete() -> Placeable:
	var hovered_furniture: PlaceableFurniture = _get_furniture_at_hovered_tile()
	if not hovered_furniture: return null
	var hovered_item: PlaceableItem = _get_hovered_item_at_furniture(hovered_furniture)
	if not hovered_item: return hovered_furniture
	return hovered_item
