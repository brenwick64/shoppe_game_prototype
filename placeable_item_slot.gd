class_name PlaceableItemSlot
extends Node2D

signal item_added(item_slot: PlaceableItemSlot, placed_item: PlaceableItem)
signal item_removed(item_slot: PlaceableItemSlot, placed_item: PlaceableItem)

@export var parent_furniture: PlaceableFurniture
@export var slot_index: int
@export var dimensions: Vector2i = Vector2i.ONE
@export var distance_from_origin: Vector2i = Vector2i.ZERO

var shoppe_items: ShoppeItems

var placed_item_id: int = -1
var placed_item: PlaceableItem

func _ready() -> void:
	var shoppe_items_ref: Node = get_tree().get_first_node_in_group("shoppe_items")
	if not shoppe_items_ref:
		push_error("PlaceableItemSlot error: no shoppe_items node found in scene tree.")
		return
	shoppe_items = shoppe_items_ref


## -- public methods --
func add_item(placeable_item: PlaceableItem) -> void:
	placeable_item.furniture_unique_id = parent_furniture.furniture_unique_id
	placeable_item.item_slot_index = slot_index
	placed_item_id = placeable_item.item_id
	placed_item = placeable_item
	add_child(placeable_item)
	shoppe_items.handle_item_added(placeable_item)
	item_added.emit(self, placeable_item)

func remove_item() -> void:
	item_removed.emit(self, placed_item)
	shoppe_items.handle_item_removed(placed_item)
	placed_item.queue_free()
	_reset_item_slot()


## -- helper functions --
func _reset_item_slot() -> void:
	placed_item_id = -1
	placed_item = null
