extends Control

@onready var recipe_entry_scene: PackedScene = preload("res://recipe_entry.tscn")

@export var crafting_book: UICraftingBook

@onready var title_label: Label = $VBoxContainer/SectionTile/HBoxContainer/Label
@onready var recipes: VBoxContainer = $VBoxContainer/RecipeList/Recipes

var _recipe_tag: String
var _filtered_recipes: Array[RRecipe]

## -- overrides --
func _ready() -> void:
	crafting_book.recipe_tag_changed.connect(_on_recipe_tag_changed)
	crafting_book.filtered_recipes_changed.connect(_on_filtered_recipes_changed)


## -- helper functions --
func _update_title_label() -> void:
	title_label.text = _recipe_tag.capitalize()

func _update_recipe_list() -> void:
	for recipe: RRecipe in _filtered_recipes:
		var recipe_entry: UIRecipeEntry = _new_recipe_entry(recipe)
		recipes.add_child(recipe_entry)

func _new_recipe_entry(recipe: RRecipe) -> UIRecipeEntry:
	var recipe_entry: UIRecipeEntry = recipe_entry_scene.instantiate()
	recipe_entry.recipe = recipe
	return recipe_entry


## -- signals --
func _on_recipe_tag_changed(new_tag: String) -> void:
	_recipe_tag = new_tag
	_update_title_label()

func _on_filtered_recipes_changed(new_filtered_recipes: Array[RRecipe]) -> void:
	_filtered_recipes = new_filtered_recipes
	_update_recipe_list()
