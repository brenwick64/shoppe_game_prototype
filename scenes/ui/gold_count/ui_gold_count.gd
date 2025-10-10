class_name UIGoldCount
extends Control

@onready var amount_label: UICountingLabel = $HBoxContainer/MarginContainer2/UICountingLabel

var current_amount: int = 0

## -- overrides --
func _ready() -> void:
	var player_currency_manager: CurrencyManager = get_tree().get_first_node_in_group("player_currency")
	if not player_currency_manager:
		push_error("UIGoldCount error: no player currency manager found.")
		return

	player_currency_manager.current_amount_changed.connect(_on_currency_amount_changed)
	current_amount = player_currency_manager.current_amount
	amount_label.set_value_immediate(current_amount)


## -- signals --
func _on_currency_amount_changed(new_amount: int) -> void:
	if new_amount == current_amount: return
	current_amount = new_amount
	amount_label.animate_to(new_amount)
