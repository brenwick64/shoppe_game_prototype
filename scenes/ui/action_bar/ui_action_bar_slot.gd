class_name UIActionBarSlot
extends Panel

signal slot_focused(slot: UIActionBarSlot)

@export var index: int = -1

@onready var centered_texture_rect: TextureRect = $CenteredTextureRect
@onready var count_label: Label = $CountLabel

var item_id: int = -1
var is_focused: bool = false


## -- public methods --
func set_focus(is_focus: bool) -> void:
	is_focused = is_focus
	queue_redraw()

func update_ui() -> void:
	if item_id == -1: 
		clear_item()
		return
	# create new item
	clear_item()
	_update_item_info(item_id)
	_update_inv_item(item_id)

func _update_item_info(item_id: int) -> void:
	var item_data: RItemData = GlobalItemDb.get_item_by_id(item_id)
	if not item_data:
		push_error("InventorySlot error: no item found for id: " + str(item_id))
		return
	centered_texture_rect.icon_scale_multiplier = item_data.icon_scale_multiplier
	centered_texture_rect.add_texture(item_data.icon_texture)

func _update_inv_item(item_id: int) -> void:
	var inv_item: RInventoryItem = GlobalPlayerInventory.get_item(item_id)
	if not inv_item: return
	count_label.add_count(inv_item.count)

#func add_item(inv_item: RInventoryItem) -> void:
	#var item_data: RItemData = GlobalItemDb.get_item_by_id(inv_item.item_id)
	#if not item_data:
		#push_error("InventorySlot error: no item found for id: " + str(inv_item.item_id))
	#item_id = inv_item.item_id
	#centered_texture_rect.icon_scale_multiplier = item_data.icon_scale_multiplier
	#centered_texture_rect.add_texture(item_data.icon_texture)
	#count_label.add_count(inv_item.count)

#func update_item_count(count: int) -> void:
	#count_label.add_count(count)

func clear_item() -> void:
	centered_texture_rect.reset_texture()
	count_label.reset_count()
	set_focus(false)

## -- overrides --
func _draw() -> void:
	if is_focused:
		draw_rect(Rect2(Vector2.ZERO, size), Color.WHITE, false, 2.0)

func _unhandled_input(event: InputEvent) -> void:
	if item_id == -1: return # cannot focus an empty slot
	if event.is_action_pressed("action_bar_" + str(index)):
		slot_focused.emit(self)

func _gui_input(event: InputEvent) -> void:
	if item_id == -1: return # cannot focus an empty slot
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		slot_focused.emit(self)
