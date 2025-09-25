class_name UIInventorySlot
extends Panel

signal slot_updated(slot: UIInventorySlot, inv_item: RInventoryItem)
signal slot_depleted(slot: UIInventorySlot)
signal slot_hovered(slot: UIInventorySlot)
signal slot_dropped()

@export var index: int = -1

@onready var drag_preview_scene: PackedScene = preload("res://scenes/ui/inventory/inventory_slot_drag_preview.tscn")
@onready var centered_texture_rect: TextureRect = $CenteredTextureRect
@onready var count_label: Label = $CountLabel

var item_id: int = -1
var is_focused: bool = false
var _is_dragged: bool = false

## -- public methods --
func get_count() -> int:
	var count: int = int(count_label.text)
	return count

func add_item(inv_item: RInventoryItem) -> void:
	var item_data: RItemData = GlobalItemDb.get_item_by_id(inv_item.item_id)
	if not item_data:
		push_error("InventorySlot error: no item found for id: " + str(inv_item.item_id))
	item_id = inv_item.item_id
	centered_texture_rect.add_texture(item_data.icon_texture)
	count_label.add_count(inv_item.count)

func update_item_count(count: int) -> void:
	count_label.add_count(count)

func hide_slot_content() -> void:
	centered_texture_rect.hide_texture()
	count_label.hide_count()

func show_slot_content() -> void:
	centered_texture_rect.show_texture()
	count_label.show_count()

func clear_item() -> void:
	item_id = -1
	centered_texture_rect.reset_texture()
	count_label.reset_count()

func set_focus(focused: bool) -> void:
	is_focused = focused
	queue_redraw()

## -- helper functions --
func _create_new_inv_item(item_id: int, count: int) -> RInventoryItem:
	var inv_item: RInventoryItem = RInventoryItem.new()
	inv_item.item_id = item_id
	inv_item.count = count
	return inv_item

func _get_drag_preview(p_item_id: int, p_count: int) -> InventorySlotDragPreview:
	var drag_preview_ins: InventorySlotDragPreview = drag_preview_scene.instantiate()
	drag_preview_ins.item_id = p_item_id
	drag_preview_ins.count = p_count
	return drag_preview_ins


## -- drag and drop --
func _get_drag_data(at_position: Vector2) -> Variant:
	var data: UIInventorySlot = self
	_is_dragged = true
	var preview: InventorySlotDragPreview = _get_drag_preview(data.item_id, data.count_label.get_count())
	set_drag_preview(preview)
	return data

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var starting_slot: UIInventorySlot = data
	var hovered: Control = get_viewport().gui_get_hovered_control()
	var hovered_inv_slot: UIInventorySlot = hovered as UIInventorySlot
	var can_drop: bool = starting_slot.item_id != hovered_inv_slot.item_id
	if not can_drop: return false
	if hovered_inv_slot:
		hovered_inv_slot.slot_hovered.emit(hovered_inv_slot)
	return can_drop

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var source_inv_slot: UIInventorySlot = data
	# remember to show the source slot (from drag)
	source_inv_slot.show_slot_content()
	
	# ensure target is another inv space
	var target: Control = get_viewport().gui_get_hovered_control()
	var target_inv_slot: UIInventorySlot = target as UIInventorySlot
	if not target_inv_slot: return
	
	var target_item_id: int
	var target_item_count: int
	var target_inv_item: RInventoryItem
	# get source inv item
	var source_item_id: int = data.item_id
	var source_item_count: int = data.get_count()
	var source_inv_item: RInventoryItem = _create_new_inv_item(source_item_id, source_item_count)
	# get target inv item (if applicable)
	if target_inv_slot.item_id != -1: # target has item
		target_item_id = target_inv_slot.item_id
		target_item_count = target_inv_slot.get_count()
		target_inv_item = _create_new_inv_item(target_item_id, target_item_count)
	
	target_inv_slot.clear_item()
	target_inv_slot.add_item(source_inv_item)
	target_inv_slot.slot_updated.emit(target_inv_slot, source_inv_item)
	
	if target_inv_item:
		source_inv_slot.clear_item()
		source_inv_slot.add_item(target_inv_item)
		source_inv_slot.slot_updated.emit(source_inv_slot, target_inv_item)
	else:
		source_inv_slot.clear_item()
		source_inv_slot.slot_depleted.emit(source_inv_slot)
		
	slot_dropped.emit()


## -- overrides --
func _input(event: InputEvent) -> void:
	# global drop - if needed
	if _is_dragged and event.is_action_released("click"):
		_is_dragged = false

func _draw() -> void:
	if is_focused:
		draw_rect(Rect2(Vector2.ZERO, size), Color.WHITE, false, 2.0)
