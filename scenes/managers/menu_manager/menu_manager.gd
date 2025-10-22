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
func show_menu(menu_name: String) -> void:
	for menu: UIMenu in menus:
		if menu.menu_name == menu_name:
			_show_menu(menu, true)
		else:
			_hide_menu(menu, false)

func hide_menu(menu_name: String) -> void:
	for menu: UIMenu in menus:
		if menu.menu_name == menu_name: 
			_hide_menu(menu, true)

func toggle_menu(menu_name: String) -> void:
	if is_menu_visible(menu_name):
		hide_menu(menu_name)
	else:
		show_menu(menu_name)	

func is_menu_visible(menu_name: String) -> bool:
	for menu: UIMenu in menus:
		if menu.menu_name == menu_name: 
			return menu.visible
	return false


## -- helper functions --
func _show_menu(menu: UIMenu, play_sound: bool) -> void:
	menu.visible = true
	if play_sound:
		menu.open_sound.play_sound()

func _hide_menu(menu: UIMenu, play_sound: bool) -> void:
	menu.visible = false
	if play_sound:
		menu.close_sound.play_sound()
