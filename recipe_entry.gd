class_name UIRecipeEntry
extends HBoxContainer

@onready var recipe_icon: TextureRect = $RecipeIconPanel/MarginContainer/TextureRect
@onready var recipe_name: Label = $RecipeNamePanel/Label

var recipe: RRecipe

func _ready() -> void:
	recipe_icon.texture = recipe.output_texture
	recipe_name.text = recipe.recipe_name
