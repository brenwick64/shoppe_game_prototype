class_name EquippedItemManager
extends Node

@export var shoppe_furniture_handler: ShoppeFurnitureHandler

@onready var item_handlers: Array = [
	shoppe_furniture_handler
]

var _current_held_item: RItemData

func _ready() -> void:
	var main_scene: Node2D = get_tree().get_first_node_in_group("main_scene")
	if not main_scene: 
		push_error("EquippedItemManager error: no main scene found.")
		return
	var player_inv_manager: Node = get_tree().get_first_node_in_group("player_inventory")
	if not player_inv_manager:
		push_error("EquippedItemManager error: no player inventory found.")
		return
	player_inv_manager.item_depleted.connect(_on_player_inv_item_depleted)
	_update_item_handlers(main_scene, player_inv_manager)


## -- helper functions --
func _update_item_handlers(main_scene: Node2D, player_inv_manager: InventoryManager) -> void:
	for handler: ItemHandler in item_handlers:
		handler.main_scene = main_scene
		handler.player_inventory_manager = player_inv_manager

func _handle_equipped_item(item_data: RItemData) -> void:
	shoppe_furniture_handler.clear_item()
	if item_data is RShoppeFurnitureData:
		shoppe_furniture_handler.set_item(item_data)


## -- signals --
func _on_ui_action_bar_item_focused(item_id: int) -> void:
	var item_data: RItemData = GlobalItemDb.get_item_by_id(item_id)
	if not item_data:
		push_error("EquippedItemManager error: no item found for equipped item id: " + str(item_id))
		return
	_current_held_item = item_data
	_handle_equipped_item(item_data)

func _on_player_inv_item_depleted(item_id: int) -> void:
	if item_id == _current_held_item.item_id:
		for handler: ItemHandler in item_handlers:
			handler.clear_item()
