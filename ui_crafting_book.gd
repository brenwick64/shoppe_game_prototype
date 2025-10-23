class_name UICraftingBook
extends UIMenu

signal recipe_tag_changed(recipe_tag: String)
signal current_recipe_changed(current_recipe: RRecipe)
signal filtered_recipes_changed(filtered_recipes: Array[RRecipe])

@onready var recipes_rg: ResourceGroup = preload("res://resources/resource_groups/rg_recipes.tres")

@onready var recipe_list_page: Control = $Panel/HBoxContainer/LeftPage/LeftMargins/RecipeListPage
@onready var page_turn_sound: OneShotSoundComponent = $PageTurnSound

var recipe_tag: String = "alchemy"
var all_recipes: Array[RRecipe]
var filtered_recipes: Array[RRecipe]
var current_recipe: RRecipe


func _ready() -> void:
	recipes_rg.load_all_into(all_recipes)
	_filter_recipes()
	# set default recipe
	if filtered_recipes:
		current_recipe = filtered_recipes[0]
		current_recipe_changed.emit(current_recipe)
		filtered_recipes_changed.emit(filtered_recipes)
	recipe_tag_changed.emit(recipe_tag)
	recipe_list_page.new_recipe_selected.connect(_on_new_recipe_selected)


## -- helper functions --
func _filter_recipes() -> void:
	filtered_recipes = all_recipes.filter(func(r: RRecipe): return recipe_tag in r.recipe_tags)


## -- signals --
func _on_new_recipe_selected(new_recipe: RRecipe) -> void:
	current_recipe = new_recipe
	current_recipe_changed.emit(current_recipe)
