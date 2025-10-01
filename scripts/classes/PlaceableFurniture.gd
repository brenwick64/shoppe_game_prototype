class_name PlaceableFurniture
extends Placeable

@export var item_slots: Node2D

var furniture_unique_id: String
var origin_tile_coords: Vector2i
var occupied_tiles: Array[Vector2i]

func _ready() -> void:
	super._ready()
	if not is_loaded_in: # assign new uuid on creation
		furniture_unique_id = uuid.v4()


## -- public methods --
func add_item_by_slot_index(item: PlaceableItem, slot_index: int) -> void:
	print("adding", item.name)
	var slots: Array[PlaceableItemSlot] = []
	for node: Node in item_slots.get_children():
		if node is PlaceableItemSlot:
			slots.append(node)
	if slots.size() < slot_index:
		push_error("PlaceableFurniture error: trying to add item into out of bounds slot index.") 
		return
	slots[slot_index].add_item(item)

func get_free_item_slots(dimensions: Vector2i) -> Array[PlaceableItemSlot]:
	var free_slots: Array[PlaceableItemSlot]
	for slot: PlaceableItemSlot in item_slots.get_children():
		if not slot.dimensions == dimensions: continue
		if not slot.placed_item_id == -1: continue
		free_slots.append(slot)
	return free_slots
