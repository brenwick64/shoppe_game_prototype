class_name PlaceableItem
extends Placeable

var furniture_unique_id: String
var item_slot_index: int


func buy_item() -> void:
	var parent_slot: PlaceableItemSlot = get_parent()
	parent_slot.item_purchased(self)
	self.visible = false
