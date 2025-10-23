extends Control

@export var crafting_book: UICraftingBook

@onready var output_texture_rect: TextureRect = $VBoxContainer/OutputSection/Panel/MarginContainer/TextureRect
@onready var recipe_description: Label = $VBoxContainer/DescriptionSection/VBoxContainer/DescriptionContainer/MarginContainer/Label

var _current_recipe: RRecipe

func _ready() -> void:
	_current_recipe = crafting_book.current_recipe
	crafting_book.current_recipe_changed.connect(_on_current_recipe_changed)
	_update_ui()


## -- helper functions --
func _update_ui() -> void:
	if not _current_recipe: return
	output_texture_rect.texture = _current_recipe.output_texture
	recipe_description.text = _current_recipe.output_desc


## -- signals --
func _on_current_recipe_changed(new_recipe: RRecipe) -> void:
	_current_recipe = new_recipe
	_update_ui()
