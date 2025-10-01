class_name ShoppeItems
extends Node2D

@export var shoppe_furniture: ShoppeFurniture
@export var save_load_component: SaveLoadComponent

var shoppe_items: Array[PlaceableItem] = []

func _ready() -> void:
	if save_load_component.check_save_data():
		_load_shoppe_items()


## -- public handlers --
func handle_item_added(placeable_item: PlaceableItem) -> void:
	shoppe_items.append(placeable_item)
	_save_shoppe_items()

func handle_item_removed(placeable_item: PlaceableItem) -> void:
	var index: int = shoppe_items.find(placeable_item)
	if index:
		shoppe_items.remove_at(index)
	_save_shoppe_items()


## -- save / load --
func _save_shoppe_items() -> void:
	save_load_component.save_data(shoppe_items)

func _load_shoppe_items() -> void:
	var loaded_data: Array = save_load_component.load_data()
	for node: Node in loaded_data:
		var shoppe_item: PlaceableItem = node
		shoppe_item.is_loaded_in = true
		_load_shoppe_item(shoppe_item)

func _load_shoppe_item(shoppe_item: PlaceableItem) -> void:
	var furniture: PlaceableFurniture = shoppe_furniture.get_furniture_by_unique_id(shoppe_item.furniture_unique_id)
	if not furniture: return
	furniture.add_item_by_slot_index(shoppe_item, shoppe_item.item_slot_index)
