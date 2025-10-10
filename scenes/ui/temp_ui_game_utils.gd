extends Control

signal tool_focused(tool: RToolItemData)

@onready var shoppe_item_remover_data: RToolItemData = preload("res://resources/r_item_data/tools/shoppe_remover.tres")
@onready var remover_tool_btn: Button = $Panel/MarginContainer/VBoxContainer/UIUtilButtons/HBoxContainer/MarginContainer/RemoverTool

func _on_remove_button_pressed() -> void:
	tool_focused.emit(shoppe_item_remover_data)

func _on_equipped_item_manager_tool_deselected() -> void:
	remover_tool_btn.release_focus()
