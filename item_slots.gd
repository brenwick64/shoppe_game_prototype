class_name ItemSlots
extends Node2D
#
#signal item_added(item_id: int)
#signal item_removed(item_id: int)
#
#func _ready() -> void:
	#for child: Node in get_children():
		#if child is not PlaceableItemSlot: continue
		#var item_slot: PlaceableItemSlot = child
		#item_slot.item_added.connect(_on_item_added)
		#item_slot.item_removed.connect(_on_item_removed)
#
#func _on_item_added(item_id: int) -> void:
	#item_added.emit(item_id)
	#
#func _on_item_removed(item_id: int) -> void:
	#item_removed.emit(item_id)
