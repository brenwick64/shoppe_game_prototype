class_name UIQuestMenu
extends Control

# TODO: load multiple of these as a resource group
@onready var harvest_resource_config: PackedScene = preload("res://scenes/ui/quest_menu/quest_configs/harvest_reasource/ui_harvest_resource_config.tscn")

@export var quest_board: QuestBoard
@export var create_quest_btn: Button
@export var quest_config_container: Control

var _current_quest_config: Control

func _ready() -> void:
	#TODO: this is temporary
	_current_quest_config = harvest_resource_config.instantiate()
	set_quest_config(_current_quest_config)
	create_quest_btn.pressed.connect(_on_create_quest_btn_pressed)


func set_quest_config(config: Control) -> void:
	# remove previous quest config(s)
	for child: Node in quest_config_container.get_children():
		child.queue_free()
	quest_config_container.add_child(config)


## -- signals --
func _on_create_quest_btn_pressed() -> void:
	var quest_config: Dictionary = _current_quest_config.get_config_data()
	quest_board.add_quest(_current_quest_config.quest_key, quest_config)
