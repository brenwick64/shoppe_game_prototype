class_name InventoryManager
extends Node

var inventory: Inventory = Inventory.new()
var inventory_ui: UIInventory

func _ready() -> void:
	var player_inv_ui: UIInventory = get_tree().get_first_node_in_group("ui_player_inventory")
	if not player_inv_ui: 
		push_error("InventoryManager error: no UI for player inventory found.")
	inventory_ui = player_inv_ui
	
	# connect signals
	inventory.item_added.connect(_on_item_added)
	inventory.item_updated.connect(_on_item_updated)
	inventory.item_depleted.connect(_on_item_depleted)


## -- signals --
func _on_item_added(new_item: RInventoryItem) -> void:
	inventory_ui.handle_item_added(new_item)

func _on_item_updated(item: RInventoryItem) -> void:
	inventory_ui.handle_item_updated(item)

func _on_item_depleted(item_id: int) -> void:
	inventory_ui.handle_item_depleted(item_id)
