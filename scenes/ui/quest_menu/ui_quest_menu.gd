class_name UIQuestMenu
extends Control

@onready var quest_data_resource_group: ResourceGroup = preload("res://resources/resource_groups/rg_quest_data.tres")

@export var quest_board: QuestBoard

@onready var quest_title_label: Label = $Panel/MarginContainer/VBoxContainer/QuestTypeSelection/Label
@onready var quest_config_container: Control = $Panel/MarginContainer/VBoxContainer/QuestConfigContainer
@onready var create_quest_btn: Button = $Panel/MarginContainer/VBoxContainer/CreateQuestBtn
@onready var quest_cost_label: UICountingLabel = $Panel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/MarginContainer2/UICountingLabel

var _quest_list: Array[RQuestData]
var _current_quest_data: RQuestData
var _current_quest_config: Control
var _current_quest_cost: int


func _ready() -> void:
	quest_data_resource_group.load_all_into(_quest_list)
	if _quest_list.is_empty():
		push_error("UIQuestMenu error. No quest resources found.")
		return
	# set initial quest state
	_current_quest_data = _quest_list[0]
	_current_quest_cost = _current_quest_data.base_cost_gold
	quest_title_label.text = _current_quest_data.quest_name
	set_quest_config(_current_quest_data.ui_config_scene)
	quest_cost_label.set_value_immediate(_current_quest_data.base_cost_gold)
	# connect signals
	create_quest_btn.pressed.connect(_on_create_quest_btn_pressed)


func set_quest_config(config_scene: PackedScene) -> void:
	# remove previous quest config(s)
	for child: Node in quest_config_container.get_children():
		child.queue_free()
	# configure new ui
	var config_ui: Control = config_scene.instantiate()
	_current_quest_config = config_ui
	_current_quest_config.quest_data = _current_quest_data
	_current_quest_config.cost_changed.connect(_on_quest_config_cost_changed)
	quest_config_container.add_child(config_ui)


## -- signals --
func _on_create_quest_btn_pressed() -> void:
	var quest_config: Dictionary = _current_quest_config.get_config_data()
	var new_quest: Quest = _current_quest_data.new_quest(quest_config)
	quest_board.add_quest(new_quest, _current_quest_cost)

func _on_quest_config_cost_changed(new_cost: int) -> void:
	_current_quest_cost = new_cost
	quest_cost_label.animate_to(_current_quest_cost)
