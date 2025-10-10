class_name CurrencyManager
extends Node

signal current_amount_changed(new_amount: int)

var ui_gold_count: UIGoldCount
#TODO: save/load
var current_amount: int = 0

## -- overrides --
func _ready() -> void:
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

func remove_currency(amount: int) -> void:
	if not has_enough_currency(amount): 
		push_error("CurrencyManager error: tried to remove more gold than player has.")
		return
	current_amount -= amount
	current_amount_changed.emit(current_amount)
