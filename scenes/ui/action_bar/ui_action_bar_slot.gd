class_name UIActionBarSlot
extends Panel

@export var index: int = -1

@onready var centered_texture_rect: TextureRect = $CenteredTextureRect
@onready var count_label: Label = $CountLabel


## -- public methods --
func add_item(inv_item: RInventoryItem) -> void:
	var item_data: RItemData = GlobalItemDb.get_item_by_id(inv_item.item_id)
	if not item_data:
		push_error("InventorySlot error: no item found for id: " + str(inv_item.item_id))
	centered_texture_rect.add_texture(item_data.icon_texture)
	count_label.add_count(inv_item.count)

func update_item_count(count: int) -> void:
	count_label.add_count(count)

func clear_item() -> void:
	centered_texture_rect.reset_texture()
	count_label.reset_count()
