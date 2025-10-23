class_name UICraftingBook
extends Control

signal recipe_tag_changed(recipe_tag: String)
signal current_recipe_changed(current_recipe: RRecipe)
signal filtered_recipes_changed(filtered_recipes: Array[RRecipe])

@onready var recipes_rg: ResourceGroup = preload("res://resources/resource_groups/rg_recipes.tres")

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


## -- helper functions --
func _filter_recipes() -> void:
	filtered_recipes = all_recipes.filter(func(r: RRecipe): return recipe_tag in r.recipe_tags)
