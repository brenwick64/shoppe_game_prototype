extends Panel

@export var interactable: Interactable
@export var quest_crate: QuestCrate

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect

func _ready() -> void:
	quest_crate.items_changed.connect(_on_quest_crate_items_changed)
	_handle_quest_items_changed(quest_crate.items)


## -- helper functions --
func _handle_quest_items_changed(items: Array[RInventoryItem]) -> void:
	if items.is_empty():
		interactable.disable_collision()
		_hide_panel_ui()
		
	else: 
		interactable.enable_collision()
		_show_panel_ui(items)

func _hide_panel_ui() -> void:
	visible = false

func _show_panel_ui(items: Array[RInventoryItem]) -> void:
	var first_item_data: RItemData = GlobalItemDb.get_item_by_id(items[0].item_id)
	texture_rect.texture = first_item_data.icon_texture
	visible = true


## -- signals --
func _on_quest_crate_items_changed(items: Array[RInventoryItem]) -> void:
	_handle_quest_items_changed(items)
