class_name PlaceableCraftingStation
extends PlaceableFurniture

@export var crafting_menu_name: String

var menu_manager: MenuManager

func _ready() -> void:
	super._ready()
	var menu_manager_node: MenuManager = get_tree().get_first_node_in_group("menu_manager")
	if not menu_manager_node:
		push_error("QuestBoard error: no QuestManager node found in main tree.")
		return
	menu_manager = menu_manager_node 


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
		if menu_manager.is_menu_visible(crafting_menu_name):
			menu_manager.hide_menu(crafting_menu_name)

func _on_interactable_interacted(interactor: Node2D) -> void:
	var interactor_parent: Node2D = interactor.get_parent()
	if interactor_parent is Player:
		menu_manager.toggle_menu(crafting_menu_name)
