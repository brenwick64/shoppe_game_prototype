class_name QuestBoard
extends StaticBody2D

@export var debug_show_quest_list: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var coin_sound: OneShotSoundComponent = $CoinSound
@onready var floating_label: FloatLabelTween = $FloatingLabel
@onready var navigation_marker: Marker2D = $NavigationMarker
@onready var debug_quest_list: Panel = $DebugQuestList

var menu_manager: MenuManager
var _quests: Array[Quest] = []

## -- public methods --
func get_quest() -> Quest:
	for quest: Quest in _quests:
		if not quest.quest_owner:
			return quest
	return null

func add_quest(new_quest: Quest, quest_cost: int) -> void:
	_quests.append(new_quest)
	coin_sound.play_sound()
	GlobalItemSpawner.spawn_coins(global_position, quest_cost)
	_remove_player_currency(quest_cost)
	_update_floating_label()
	menu_manager.hide_menu("quest_menu")


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
	var menu_manager_node: MenuManager = get_tree().get_first_node_in_group("menu_manager")
	if not menu_manager_node:
		push_error("QuestBoard error: no QuestManager node found in main tree.")
		return
	menu_manager = menu_manager_node 
	_update_floating_label()


## -- helper functions --
func _update_floating_label() -> void:
	var is_new_quests: bool = _quests.filter(
		func(q: Quest): return q.quest_status == Constants.QUEST_STATUS.NONE
	).size() > 0
	floating_label.visible = is_new_quests
	# debug
	debug_quest_list.update_list(_quests)

func _remove_player_currency(amount: int) -> void:
	var player_currency_manager: CurrencyManager = get_tree().get_first_node_in_group("player_currency")
	if not player_currency_manager:
		push_error("QuestBoard error: cannot find player currency manager")
		return
	player_currency_manager.remove_currency(amount)

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
		if menu_manager.is_menu_visible("quest_menu"):
			menu_manager.hide_menu("quest_menu")

func _on_interactable_interacted(interactor: Node2D) -> void:
	var interactor_parent: Node2D = interactor.get_parent()
	if interactor_parent is Player:
		menu_manager.toggle_menu("quest_menu")
