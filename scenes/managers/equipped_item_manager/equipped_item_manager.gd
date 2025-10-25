class_name EquippedItemManager
extends Node

signal item_deselected
signal tool_deselected

@export var shoppe_furniture_handler: ShoppeFurnitureHandler
@export var shoppe_item_handler: ShoppeItemHandler
@export var shoppe_remover_handler: ShoppeRemoverHandler

@onready var item_handlers: Array = [
	shoppe_furniture_handler,
	shoppe_item_handler
]

@onready var tool_handlers: Array = [
	shoppe_remover_handler
]

var _current_selected_tool: RToolItemData
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
	var player: Player = get_tree().get_first_node_in_group("player")
	if not player:
		push_error("EquippedItemManager error: no player found.")
		return
	player_inv_manager.item_depleted.connect(_on_player_inv_item_depleted)
	_initialize_item_handlers(main_scene, player_inv_manager)
	_initialize_tool_handlers(main_scene, player)


## -- helper functions --
func _initialize_item_handlers(main_scene: Node2D, player_inv_manager: InventoryManager) -> void:
	for handler: ItemHandler in item_handlers:
		handler.main_scene = main_scene
		handler.player_inventory_manager = player_inv_manager

func _initialize_tool_handlers(main_scene: Node2D, player: Player) -> void:
	for handler: ItemHandler in tool_handlers:
		handler.main_scene = main_scene
		handler.player = player

func _clear_handlers() -> void:
	for handler: ItemHandler in item_handlers:
		handler.clear_item()
	for handler: ItemHandler in tool_handlers:
		handler.clear_item()

func _clear_item_handlers() -> void:
	for handler: ItemHandler in item_handlers:
		handler.clear_item()

func _clear_tool_handlers() -> void:
	for handler: ItemHandler in tool_handlers:
		handler.clear_item()

func _handle_equipped_item(item_data: RItemData) -> void:
	if item_data is RShoppeFurnitureData:
		shoppe_furniture_handler.set_item(item_data)
	elif item_data is RShoppeItemData:
		shoppe_item_handler.set_item(item_data)

func _handle_equipped_tool(tool: RToolItemData) -> void:
	if tool.tool_name == "shoppe_item_remover":
		shoppe_remover_handler.set_item(tool)


## -- signals --
func _on_ui_action_bar_item_focused(item_id: int) -> void:
	var item_data: RItemData = GlobalItemDb.get_item_by_id(item_id)
	if not item_data:
		push_error("EquippedItemManager error: no item found for equipped item id: " + str(item_id))
		return
	# clear other handlers
	_current_selected_tool = null
	_clear_handlers()
	# enable item handler
	_current_held_item = item_data
	_handle_equipped_item(item_data)
	tool_deselected.emit()

func _on_player_inv_item_depleted(item_id: int) -> void:
	if not _current_held_item: return
	if item_id == _current_held_item.item_id:
		for handler: ItemHandler in item_handlers:
			handler.clear_item()

func _on_temp_ui_game_utils_tool_focused(tool: RToolItemData) -> void:
	# clear other handlers
	_current_held_item = null
	_clear_handlers()
	# enable tool handler
	_current_selected_tool = tool
	_handle_equipped_tool(tool)
	item_deselected.emit()
