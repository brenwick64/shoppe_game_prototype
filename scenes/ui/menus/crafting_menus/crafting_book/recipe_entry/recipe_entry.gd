class_name UIRecipeEntry
extends HBoxContainer

@onready var ingredient_panel: PackedScene = preload("res://scenes/ui/menus/crafting_menus/crafting_book/ingredient_panel/ingredient_panel.tscn")

signal recipe_selected(recipe_entry: UIRecipeEntry)

# recipe icon
@onready var recipe_icon: TextureRect = $RecipeIconBtn/MarginContainer/TextureRect
@onready var recipe_icon_btn: Button = $RecipeIconBtn
@onready var focus_texture: TextureRect = $RecipeIconBtn/FocusTexture
# ingredients list
@onready var ingredients_list: HBoxContainer = $IngredientsPanel/MarginContainer/HBoxContainer


var recipe: RRecipe
var is_focused: bool = false

## -- overrides --
func _ready() -> void:
	recipe_icon.texture = recipe.output_texture
	recipe_icon_btn.pressed.connect(_on_recipe_icon_btn_pressed)
	_add_ingredient_panels()
	_update_ui()


## -- public methods --
func set_focus(p_is_focused: bool) -> void:
	is_focused = p_is_focused
	_update_ui()


## -- helper functions
func _update_ui() -> void:
	focus_texture.visible = is_focused

func _add_ingredient_panels() -> void:
	for input_ingredient: RInventoryItem in recipe.input_items:
		var ingredient_ui: UIIngredientPanel = ingredient_panel.instantiate()
		ingredient_ui.ingredient = input_ingredient
		ingredients_list.add_child(ingredient_ui)


## -- signals --
func _on_recipe_icon_btn_pressed() -> void:
	recipe_selected.emit(self)
