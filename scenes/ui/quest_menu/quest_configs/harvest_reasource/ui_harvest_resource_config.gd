class_name UIHarvestResourceConfig
extends Control

@export var quest_key: String

@onready var rg_harvestable_data: ResourceGroup = preload("res://resources/resource_groups/rg_harvestable_data.tres")
## static data views
@onready var count_title_label: Label = $MarginContainer/VBoxContainer/QuestTitle2/CountTitleLabel
@onready var harvestable_title_label: Label = $MarginContainer/VBoxContainer/QuestTitle2/HarvestableTitleLabel
@onready var harvestable_texture: TextureRect = $MarginContainer/VBoxContainer/HarvestableSelection/HarvestableTexture
@onready var count_label: Label = $MarginContainer/VBoxContainer/CountSelection/CountLabel
## buttons
@onready var harvestable_left_btn: Button = $MarginContainer/VBoxContainer/HarvestableSelection/LeftBtn
@onready var harvestable_right_btn: Button = $MarginContainer/VBoxContainer/HarvestableSelection/RightBtn
@onready var count_left_btn: Button = $MarginContainer/VBoxContainer/CountSelection/LeftBtn
@onready var count_right_btn: Button = $MarginContainer/VBoxContainer/CountSelection/RightBtn

var harvestables: Array[RHarvestableData]

var _current_harvestable: RHarvestableData
var _current_count: int = 1


func _ready() -> void:
	harvestable_left_btn.pressed.connect(_on_harvestable_left_btn_pressed)
	harvestable_right_btn.pressed.connect(_on_harvestable_right_btn_pressed)
	count_left_btn.pressed.connect(_on_count_left_btn_pressed)
	count_right_btn.pressed.connect(_on_count_right_btn_pressed)
	rg_harvestable_data.load_all_into(harvestables)
	if not harvestables:
		push_error("UIHarvestResourceConfig error: no harvestable data found in resource group.")
		return
	_current_harvestable = harvestables[0]
	_update_ui()


## -- public methods --
func get_config_data() -> Dictionary:
	var config_data: Dictionary = {}
	config_data["harvestable"] = _current_harvestable
	config_data["count"] = _current_count
	return config_data


## -- helper functions --
func _update_ui() -> void:
	_update_quest_text()
	_update_harvestable_texture()

func _update_quest_text() -> void:
	count_title_label.text = str(_current_count)
	harvestable_title_label.text = _current_harvestable.harvestable_name_plural if _current_count > 1 else _current_harvestable.harvestable_name
	count_label.text = str(_current_count)

func _update_harvestable_texture() -> void:
	harvestable_texture.texture = _current_harvestable.texture


## -- signals --
func _on_harvestable_left_btn_pressed() -> void:
	var current_harvestable_index: int = harvestables.find(_current_harvestable)
	if current_harvestable_index == 0:
		_current_harvestable = harvestables[harvestables.size() - 1]
	else:
		_current_harvestable = harvestables[current_harvestable_index - 1]
	_update_ui()
	
func _on_harvestable_right_btn_pressed() -> void:
	var current_harvestable_index: int = harvestables.find(_current_harvestable)
	if current_harvestable_index == harvestables.size() - 1:
		_current_harvestable = harvestables[0]
	else:
		_current_harvestable = harvestables[current_harvestable_index + 1]
	_update_ui()
	
func _on_count_left_btn_pressed() -> void:
	_current_count = max(1, _current_count - 1)
	_update_ui()
	
func _on_count_right_btn_pressed() -> void:
	_current_count = min(9, _current_count + 1)
	_update_ui()
