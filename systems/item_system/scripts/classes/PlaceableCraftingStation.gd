class_name PlaceableCraftingStation
extends PlaceableFurniture

@export var crafting_type: String

# crafting component
@onready var crafting_component: CraftingComponent = $CraftingComponent
@onready var lootable_component: LootableComponent = $LootableComponent
@onready var interactable: Interactable = $Interactable

const CRAFTING_MENU_NAME: String = "ui_crafting_book"

var menu_manager: MenuManager

func _ready() -> void:
	super._ready()
	var menu_manager_node: MenuManager = get_tree().get_first_node_in_group("menu_manager")
	if not menu_manager_node:
		push_error("QuestBoard error: no QuestManager node found in main tree.")
		return
	menu_manager = menu_manager_node
	GlobalItemSpawner.spawn_item_pickup(
		103, 
		1, 
		global_position, 
		global_position + Vector2(0, 20),
		get_tree().get_first_node_in_group("player")
		)

## -- public methods --
func craft(recipe: RRecipe, player: Player) -> void:
	crafting_component.craft(recipe)
	interactable.disable_collision()
	

## -- helper functions --
func _show_outline() -> void:
	var shader_material: ShaderMaterial = sprite.material
	shader_material.set_shader_parameter("width", 0.55)  
	shader_material.set_shader_parameter("pattern", 1)

func _hide_outline() -> void:
	var shader_material: ShaderMaterial = sprite.material
	shader_material.set_shader_parameter("width", 0)
	shader_material.set_shader_parameter("pattern", 1)


## -- signals --
func _on_interactable_focus_changed(is_focused: bool) -> void:
	if is_focused: 
		_show_outline()
	else:
		_hide_outline()
		# hide menu upon leaving interactable AOE
		if menu_manager.is_menu_visible(CRAFTING_MENU_NAME):
			menu_manager.hide_menu(CRAFTING_MENU_NAME)

func _on_interactable_interacted(interactor: Node2D) -> void:
	var interactor_parent: Node2D = interactor.get_parent()
	if not interactor_parent is Player: return
	if lootable_component.lootable_items:
		var looted_items: Array[RInventoryItem] = lootable_component.loot_all_items()
		interactor_parent.inventory_manager.inventory.add_items(looted_items)
	else:
		menu_manager.toggle_menu(CRAFTING_MENU_NAME, self, interactor_parent)


func _on_crafting_component_crafting_finished(recipe: RRecipe) -> void:
	interactable.enable_collision()
	for inv_item: RInventoryItem in recipe.output_items:
		lootable_component.deposit_items(inv_item.item_id, inv_item.count)
