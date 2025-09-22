extends Node

var item_data_rg: ResourceGroup = preload("res://resources/resource_groups/rg_item_data.tres")

var items_arr: Array[RItemData]

func _ready() -> void:
	item_data_rg.load_all_into(items_arr)

func get_item_by_id(item_id: int) -> RItemData:
	for item: RItemData in items_arr:
		if item.item_id == item_id:
			return item
	return null
