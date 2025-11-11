class_name UIPickupToastNotifications
extends Control

@export var parent_canvas_layer: CanvasLayer

@onready var item_toast_scene: PackedScene = preload("res://scenes/ui/toast_notifications/item_toast_ui/item_toast_ui.tscn")
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer


## -- public methods --
func add_pickup_toast(item_id: int, count: int) -> void:
	var matching_toast: ItemToastUI = _get_existing_item_toast(item_id)
	if matching_toast:
		matching_toast.update_toast(item_id, count)
	else:
		_add_new_toast(item_id, count)


## -- overrides --
func _ready() -> void:
	GlobalPlayerInventory.item_aquired.connect(_on_item_aquired)

## -- helper functions --
func _add_new_toast(item_id: int, count: int) -> void:
	var new_toast: ItemToastUI = item_toast_scene.instantiate()
	new_toast.item_id = item_id
	new_toast.item_count = count
	v_box_container.add_child(new_toast)

func _get_existing_item_toast(item_id: int) -> Control:
	for node: Node in v_box_container.get_children():
		var item_toast: ItemToastUI = node as ItemToastUI
		if item_toast.item_id == item_id:
			return item_toast
	return null


## -- signals --
func _on_item_aquired(item_id: int, count: int) -> void:
	add_pickup_toast(item_id, count)
