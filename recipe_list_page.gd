extends Control

signal new_recipe_selected(recipe: RRecipe)

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
		var recipe_entry: UIRecipeEntry = recipe_entry_scene.instantiate()
		recipe_entry.recipe_selected.connect(_on_recipe_selected)
		recipe_entry.recipe = recipe
		recipes.add_child(recipe_entry)

func _clear_recipe_list() -> void:
	for node: Node in recipes.get_children():
		node.queue_free()

func _set_recipe_entries_focus(focused_entry: UIRecipeEntry) -> void:
	for node: Node in recipes.get_children():
		if node == focused_entry:
			node.set_focus(true)
		else:
			node.set_focus(false)

func _get_first_entry() -> UIRecipeEntry:
	var recipes: Array[Node] = recipes.get_children()
	if recipes.is_empty(): return
	return recipes[0]


## -- signals --
func _on_recipe_tag_changed(new_tag: String) -> void:
	_recipe_tag = new_tag
	_update_title_label()

func _on_filtered_recipes_changed(new_filtered_recipes: Array[RRecipe]) -> void:
	_filtered_recipes = new_filtered_recipes
	_clear_recipe_list()
	_update_recipe_list()
	# focuses the first entry
	_set_recipe_entries_focus(_get_first_entry())


func _on_recipe_selected(recipe_entry: UIRecipeEntry) -> void:
	var is_new_selection: bool = recipe_entry.is_focused == false
	# only trigger on new selections
	if is_new_selection:
		crafting_book.page_turn_sound.play_sound()
		new_recipe_selected.emit(recipe_entry.recipe)
	_set_recipe_entries_focus(recipe_entry)
