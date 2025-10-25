class_name MenuManager
extends Node

var menus: Array[UIMenu]

## -- overrides --
func _ready() -> void:
	var menu_ui: CanvasLayer = get_tree().get_first_node_in_group("menu_ui")
	if not menu_ui:
		push_error("MenuManager error. no MenuUI CanvasLayer found.")
		return
	for node: Node in menu_ui.get_children():
		if node is not UIMenu: continue
		menus.append(node)


## -- public methods --
func show_menu(menu_name: String, toggled_from: Node2D, toggled_by: Player) -> void:
	for menu: UIMenu in menus:
		if menu.menu_name == menu_name:
			menu.show_menu(toggled_from, toggled_by, true)
		else:
			menu.hide_menu(false)

func hide_menu(menu_name: String) -> void:
	for menu: UIMenu in menus:
		if menu.menu_name == menu_name: 
			menu.hide_menu(true)

func toggle_menu(menu_name: String, toggled_from: Node2D, toggled_by: Player) -> void:
	if is_menu_visible(menu_name):
		hide_menu(menu_name)
	else:
		show_menu(menu_name, toggled_from, toggled_by)

func is_menu_visible(menu_name: String) -> bool:
	for menu: UIMenu in menus:
		if menu.menu_name == menu_name: 
			return menu.visible
	return false
