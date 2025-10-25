extends Panel

@export var lootable_component: LootableComponent

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect


## -- overrides --
func _ready() -> void:
	lootable_component.items_changed.connect(_on_lootable_component_items_changed)


## -- helper functions --
func _hide_panel_ui() -> void:
	texture_rect.texture = null
	visible = false

func _show_panel_ui(items: Array[RInventoryItem]) -> void:
	var first_item_data: RItemData = GlobalItemDb.get_item_by_id(items[0].item_id)
	texture_rect.texture = first_item_data.icon_texture
	visible = true


## -- signals --
func _on_lootable_component_items_changed(new_items: Array[RInventoryItem]) -> void:
	if not new_items: _hide_panel_ui()
	else: _show_panel_ui(new_items)
