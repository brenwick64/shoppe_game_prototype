class_name UICraftingBook
extends UIMenu

signal recipe_tag_changed(recipe_tag: String)
signal current_recipe_changed(current_recipe: RRecipe)
signal filtered_recipes_changed(filtered_recipes: Array[RRecipe])

@onready var recipes_rg: ResourceGroup = preload("res://resources/resource_groups/rg_recipes.tres")

@onready var recipe_list_page: Control = $Panel/HBoxContainer/LeftPage/LeftMargins/RecipeListPage
@onready var page_turn_sound: OneShotSoundComponent = $PageTurnSound
@onready var decline_sound: OneShotSoundComponent = $DeclineSound
@onready var craft_btn: Button = $Panel/HBoxContainer/RightPage/RightMargins/RecipeInformationPage/VBoxContainer/CraftBtn


var recipe_tag: String
var all_recipes: Array[RRecipe]
var filtered_recipes: Array[RRecipe]
var current_recipe: RRecipe

var _current_toggled_from: Node2D
var _current_toggled_by: Player


## -- overrides --
func _ready() -> void:
	recipes_rg.load_all_into(all_recipes)
	_filter_recipes()
	# set default recipe
	if filtered_recipes:
		current_recipe = filtered_recipes[0]
		current_recipe_changed.emit(current_recipe)
	else:
		current_recipe_changed.emit(null)
	filtered_recipes_changed.emit(filtered_recipes)
	recipe_tag_changed.emit(recipe_tag)
	recipe_list_page.new_recipe_selected.connect(_on_new_recipe_selected)
	craft_btn.pressed.connect(_on_craft_btn_pressed)

func show_menu(toggled_from: Node2D, toggled_by: Player, play_sound: bool = false) -> void:
	super.show_menu(toggled_from, toggled_by, play_sound)
	_current_toggled_from = toggled_from
	_current_toggled_by = toggled_by
	var crafting_station: PlaceableCraftingStation = toggled_from
	set_recipe_tag(crafting_station.crafting_type)

func hide_menu(play_sound: bool = false) -> void:
	super.hide_menu(play_sound)
	_current_toggled_from = null
	_current_toggled_by = null
	recipe_tag = ""
	filtered_recipes = []
	current_recipe = null
	recipe_tag_changed.emit(recipe_tag)
	recipe_tag_changed.emit(recipe_tag)
	current_recipe_changed.emit(current_recipe)


## -- public methods --
func set_recipe_tag(new_tag: String) -> void:
	recipe_tag = new_tag
	recipe_tag_changed.emit(recipe_tag)
	_filter_recipes()
	filtered_recipes_changed.emit(filtered_recipes)
	if filtered_recipes:
		current_recipe = filtered_recipes[0]
		current_recipe_changed.emit(current_recipe)
	else:
		current_recipe_changed.emit(null)


## -- helper functions --
func _filter_recipes() -> void:
	filtered_recipes = all_recipes.filter(func(r: RRecipe): return recipe_tag in r.recipe_tags)

func _remove_player_items(player: Player, inv_items: Array[RInventoryItem]) -> void:
	for inv_item: RInventoryItem in inv_items:
		player.inventory_manager.inventory.remove_item(inv_item.item_id, inv_item.count)


## -- signals --
func _on_new_recipe_selected(new_recipe: RRecipe) -> void:
	current_recipe = new_recipe
	current_recipe_changed.emit(current_recipe)

func _on_craft_btn_pressed() -> void:
	if not current_recipe: return
	var has_items: bool = _current_toggled_by.inventory_manager.inventory.has_items(current_recipe.input_items)
	#TODO: show notification
	if not has_items: 
		decline_sound.play_sound()
	if has_items:
		_remove_player_items(_current_toggled_by, current_recipe.input_items)
		_current_toggled_from.craft(current_recipe, _current_toggled_by) 
		hide_menu(false)
