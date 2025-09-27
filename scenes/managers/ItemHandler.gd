class_name ItemHandler
extends Node

var main_scene: Node2D
var player_inventory_manager: InventoryManager

var _current_item_data: RItemData

## -- public methods --
func set_item(item_data: RPlaceableItemData) -> void:
	_current_item_data = item_data

func clear_item() -> void:
	_current_item_data = null
