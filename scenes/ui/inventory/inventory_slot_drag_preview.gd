class_name InventorySlotDragPreview
extends Panel

@onready var centered_texture_rect: TextureRect = $CenteredTextureRect
@onready var count_label: Label = $CountLabel

var item_id: int = -1
var count: int = 0
var item_data: RItemData

func _ready() -> void:
	var data: RItemData = GlobalItemDb.get_item_by_id(item_id)
	item_data = data
	_populate_child_nodes()

## -- helper functions --
func _populate_child_nodes() -> void:
	if not item_data: return
	centered_texture_rect.add_texture(item_data.icon_texture)
	count_label.add_count(count)
