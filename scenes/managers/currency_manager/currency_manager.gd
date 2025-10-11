class_name CurrencyManager
extends Node

signal current_amount_changed(new_amount: int)

@onready var save_load_component: SaveLoadComponent = $SaveLoadComponent

var ui_gold_count: UIGoldCount
var current_amount: int = 0

## -- overrides --
func _ready() -> void:
	var save_data_exists: bool = save_load_component.check_save_data()
	if save_data_exists:
		_load_inventory()
	var ui_gold_count_node: UIGoldCount = get_tree().get_first_node_in_group("ui_gold_count")
	if not ui_gold_count_node:
		push_error("CurrencyManager error: no UIGoldCount found. cannot display gold.")
		return
	ui_gold_count = ui_gold_count_node


## -- public methods --
func has_enough_currency(amount_to_remove: int) -> bool:
	return current_amount >= amount_to_remove

func add_currency(amount: int) -> void:
	current_amount += amount
	current_amount_changed.emit(current_amount)
	_save_currency()

func remove_currency(amount: int) -> void:
	if not has_enough_currency(amount): 
		push_error("CurrencyManager error: tried to remove more gold than player has.")
		return
	current_amount -= amount
	current_amount_changed.emit(current_amount)
	_save_currency()


## -- save/load --
func _save_currency():
	if not save_load_component: return
	save_load_component.save_data([{ "type": "gold", "amount": current_amount }])

func _load_inventory():
	var loaded_data: Array = save_load_component.load_data()
	for data: Dictionary in loaded_data:
		if data["type"] == "gold":
			current_amount = data["amount"]
			current_amount_changed.emit(current_amount)
