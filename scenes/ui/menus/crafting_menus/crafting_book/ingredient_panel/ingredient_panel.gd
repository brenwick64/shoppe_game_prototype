class_name UIIngredientPanel
extends Panel

@onready var ingredient_texture: TextureRect = $MarginContainer/IngredientTexture
# labels
@onready var player_inventory_count: Label = $HBoxContainer/PlayerInventoryCount
@onready var slash: Label = $HBoxContainer/Slash
@onready var ingredient_count: Label = $HBoxContainer/IngredientCount
@onready var FONT_BASE_COLOR: Color = slash.get_theme_color("font_color")

const NUMBER_CUTOFF_VALUE: int = 99

var ingredient: RInventoryItem
var player_inventory: Inventory


func _ready() -> void:
	player_inventory = _get_player_inventory()
	_set_ingredient_texture()
	_set_inventory_count(player_inventory)
	_set_ingredient_count()
	player_inventory.item_added.connect(_on_item_added)
	player_inventory.item_updated.connect(_on_item_updated)
	player_inventory.item_depleted.connect(_on_item_depleted)

## -- helper functions --
func _get_player_inventory() -> Inventory:
	var player: Player = get_tree().get_first_node_in_group("player")
	if not player:
		push_error("UIIngredientPanel error. player node not in tree.")
	return player.inventory_manager.inventory

func _set_ingredient_texture() -> void:
	var inv_ingredient: RInventoryItem = player_inventory.get_inventory_item(ingredient.item_id)
	var item_data: RItemData = GlobalItemDb.get_item_by_id(ingredient.item_id)
	ingredient_texture.texture = item_data.icon_texture

func _set_inventory_count(player_inventory: Inventory) -> void:
	# tally count
	var count: int
	var count_text: String
	var inv_ingredient: RInventoryItem = player_inventory.get_inventory_item(ingredient.item_id)
	if not inv_ingredient: count = 0
	else: count = inv_ingredient.count
	# handle ui
	if count == 0:
		count_text = "0"
		_set_label_colors(Constants.ERROR_TEXT)
	elif count > NUMBER_CUTOFF_VALUE:
		count_text = "*"
		_set_label_colors(FONT_BASE_COLOR)
	else:
		count_text = str(count)
		_set_label_colors(FONT_BASE_COLOR)
		
	player_inventory_count.text = count_text

func _set_ingredient_count() -> void:
	ingredient_count.text = str(ingredient.count)

func _set_label_colors(color: Color) -> void:
	player_inventory_count.add_theme_color_override("font_color", color)
	slash.add_theme_color_override("font_color", color)
	ingredient_count.add_theme_color_override("font_color", color)


## -- signals --
func _on_item_added(_inv_item: RInventoryItem) -> void:
	_set_inventory_count(player_inventory)
func _on_item_updated(_inv_item: RInventoryItem) -> void:
	_set_inventory_count(player_inventory)
func _on_item_depleted(_item_id: int) -> void:
	_set_inventory_count(player_inventory)
