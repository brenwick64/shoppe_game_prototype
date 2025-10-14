class_name UIQuestMenu
extends Control

@export var quest_board: QuestBoard
@export var create_quest_btn: Button

func _ready() -> void:
	create_quest_btn.pressed.connect(_on_create_quest_btn_pressed)


## -- signals --
func _on_create_quest_btn_pressed() -> void:
	quest_board.add_quest()
