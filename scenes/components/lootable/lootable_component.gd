class_name LootableComponent
extends Node2D

signal items_changed(lootable_items: Array[RInventoryItem])

@export var loot_audio: RAudioStreamData
@export var ui_z_index_modifier: int = 0

@onready var lootable_items_panel: Panel = $LootableItemsPanel
@onready var loot_sound: OneShotSoundComponent = $LootSound

var lootable_items: Array[RInventoryItem]

func _ready() -> void:
	lootable_items_panel.z_index = lootable_items_panel.z_index + ui_z_index_modifier
	loot_sound.load_audio_data(loot_audio)


## -- public methods --
#TODO: refactor to use inventory items as input
func deposit_items(item_id: int, count: int) -> void:
	var item_index: int = _get_item_index(item_id)
	if item_index == -1:
		_add_inv_item(item_id, count)
	else:
		_update_inv_item(item_index, count)
	items_changed.emit(lootable_items)

func loot_all_items() -> Array[RInventoryItem]:
	var looted_items: Array[RInventoryItem] = lootable_items
	lootable_items = []
	items_changed.emit(lootable_items)
	loot_sound.play_sound()
	return looted_items


## -- helper functions --
func _get_item_index(item_id: int) -> int:
	for inv_item: RInventoryItem in lootable_items:
		if inv_item.item_id == item_id:
			return lootable_items.find(inv_item)
	return -1

func _add_inv_item(item_id: int, count: int) -> void:
	var inv_item: RInventoryItem = RInventoryItem.new()
	inv_item.item_id = item_id
	inv_item.count = count
	lootable_items.append(inv_item)

func _update_inv_item(item_index: int, count: int) -> void:
	var inv_item: RInventoryItem = lootable_items[item_index]
	inv_item.count += count
