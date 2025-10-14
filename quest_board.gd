class_name QuestBoard
extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var menu_open: OneShotSoundComponent = $MenuOpen
@onready var menu_close: OneShotSoundComponent = $MenuClose
@onready var floating_label: FloatLabelTween = $FloatingLabel

var quest_ui: UIQuestMenu

var _available_quests: Array[String] = []
var _active_quests: Array[String] = []


## -- public methods --
func add_quest() -> void:
	_available_quests.append("placeholder")
	_update_floating_label()
	_toggle_ui()


## -- npc methods --
func npc_get_quest() -> String:
	if not _available_quests: return ""
	return "PLACEHOLDER"

func npc_turn_in_quest() -> void:
	print("quest turned in.")


## -- overrides --
func _ready() -> void:
	var quest_menu_ui: UIQuestMenu = get_tree().get_first_node_in_group("ui_quest_menu")
	if not quest_menu_ui:
		push_error("QuestBoard error: no UIQuestMenu found in main tree.")
		return
	quest_ui = quest_menu_ui
	_update_floating_label()


## -- helper functions --
func _update_floating_label() -> void:
	floating_label.visible = _available_quests.size() > 0

func _toggle_ui() -> void:
	if quest_ui.visible:
		quest_ui.visible = false
		menu_close.play_sound()
	elif not quest_ui.visible:
		quest_ui.visible = true
		menu_open.play_sound()

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
		return
	else:
		_hide_outline()
		if quest_ui.visible:
			_toggle_ui()

func _on_interactable_interacted(interactor: Node2D) -> void:
	var interactor_parent: Node2D = interactor.get_parent()
	if interactor_parent is Player:
		_toggle_ui()
