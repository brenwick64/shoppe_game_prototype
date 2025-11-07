class_name IngredientToolTip
extends Panel

@export var parent: Node

@onready var name_label: Label = $MarginContainer/VBoxContainer/Name
@onready var type_label: Label = $MarginContainer/VBoxContainer/Type
@onready var description_label: Label = $MarginContainer/VBoxContainer/Description

var _ingredient: RInventoryItem

func _ready() -> void:
	_ingredient = parent.ingredient
	var item_data: RItemData = GlobalItemDb.get_item_by_id(_ingredient.item_id)
	if not item_data: 
		return
	_add_name(item_data)
	_add_type(item_data)
	_add_description(item_data)


## - helper functions --
func _add_name(item_data: RItemData) -> void:
	name_label.text = item_data.item_name
	
func _add_type(item_data: RItemData) -> void:
	var item_type_str: String = Constants.ITEM_TYPES.keys()[item_data.item_type]
	var item_type_color: Color = Constants.get_item_type_color(item_data.item_type)
	type_label.add_theme_color_override("font_color", item_type_color)
	type_label.text = item_type_str.to_lower().capitalize()

func _add_description(item_data: RItemData) -> void:
	description_label.text = item_data.item_tooltip_desc
