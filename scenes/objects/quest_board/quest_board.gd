class_name QuestBoard
extends StaticBody2D

@export var debug_show_quest_list: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var menu_open: OneShotSoundComponent = $MenuOpen
@onready var menu_close: OneShotSoundComponent = $MenuClose
@onready var floating_label: FloatLabelTween = $FloatingLabel
@onready var navigation_marker: Marker2D = $NavigationMarker
@onready var debug_quest_list: Panel = $DebugQuestList

var quest_ui: UIQuestMenu
var _quests: Array[Quest] = []

## -- public methods --
func get_quest() -> Quest:
	for quest: Quest in _quests:
		if not quest.quest_owner:
			return quest
	return null


func add_quest(quest_key: String, quest_config: Dictionary) -> void:
	var new_quest: Quest = GlobalQuestManager.new_quest(quest_key, quest_config)
	_quests.append(new_quest)
	_update_floating_label()
	_toggle_ui()


## -- npc methods --
func npc_reserve_quest(adventurer: Adventurer) -> bool:
	var new_quest: Quest = get_quest()
	if not new_quest: return false
	new_quest.quest_owner = adventurer
	# debug
	debug_quest_list.update_list(_quests)
	return true

func npc_get_quest(adventurer: Adventurer) -> Quest:
	var npc_quest: Quest
	for quest: Quest in _quests:
		if quest.quest_owner == adventurer:
			quest.quest_status = Constants.QUEST_STATUS.STARTED
			_update_floating_label()
			return quest
	return null

func npc_complete_quest(adventurer: Adventurer) -> void:
	var completed_quest_index: int = -1
	for quest: Quest in _quests:
		if quest.quest_owner == adventurer:
			completed_quest_index = _quests.find(quest)
	if completed_quest_index != -1:
		_quests.remove_at(completed_quest_index)
	_update_floating_label()
	print("quest complete.")


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
	var is_new_quests: bool = _quests.filter(
		func(q: Quest): return q.quest_status == Constants.QUEST_STATUS.NONE
	).size() > 0
	floating_label.visible = is_new_quests
	# debug
	debug_quest_list.update_list(_quests)

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
