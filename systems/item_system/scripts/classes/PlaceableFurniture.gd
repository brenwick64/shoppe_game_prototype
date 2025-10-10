class_name PlaceableFurniture
extends Placeable

@export var item_slots_node: Node2D

var furniture_unique_id: String
var origin_tile_coords: Vector2i
var occupied_tiles: Array[Vector2i]

var _item_slots: Array[PlaceableItemSlot] = []
var _occupied_item_tiles: Array[Vector2i]


func _ready() -> void:
	super._ready()
	if not is_loaded_in: # assign new uuid on creation
		furniture_unique_id = uuid.v4()
	# populate item slot array
	for node: Node in item_slots_node.get_children():
		var item_slot: PlaceableItemSlot = node
		item_slot.item_added.connect(_on_item_slot_item_added)
		item_slot.item_removed.connect(_on_item_slot_item_removed)
		_item_slots.append(item_slot)


## -- public methods --
func add_item_by_slot_index(item: PlaceableItem, slot_index: int) -> void:
	if _item_slots.size() < slot_index:
		push_error("PlaceableFurniture error: trying to add item into out of bounds slot index.") 
		return
	_item_slots[slot_index].add_item(item)

func get_full_item_slots() -> Array[PlaceableItemSlot]:
	var full_slots: Array[PlaceableItemSlot] = []
	for slot: PlaceableItemSlot in _item_slots:
		if slot.placed_item:
			full_slots.append(slot)
	return full_slots

func get_free_item_slots(item_dimensions: Vector2i) -> Array[PlaceableItemSlot]:
	var free_slots: Array[PlaceableItemSlot] = []
	for slot: PlaceableItemSlot in _item_slots:
		if not slot.dimensions == item_dimensions: continue
		if not slot.placed_item_id == -1: continue
		if not _has_empty_item_coords(slot): continue
		free_slots.append(slot)
	return free_slots


## -- helper functions --
func _has_empty_item_coords(item_slot: PlaceableItemSlot) -> bool:
	var coords_needed: Array[Vector2i] = _get_needed_item_coords(item_slot)
	var has_coords: bool = not Utils.arrays_overlap(coords_needed, _occupied_item_tiles)
	return has_coords

func _get_needed_item_coords(item_slot: PlaceableItemSlot) -> Array[Vector2i]:
	var coords_needed: Array[Vector2i] = []
	var xform_matrix: Array[Vector2i] = Utils.create_transformation_matrix(item_slot.dimensions)
	for vector: Vector2i in xform_matrix:
		coords_needed.append(origin_tile_coords + vector + item_slot.distance_from_origin)
	return coords_needed


## -- signals --
func _on_item_slot_item_added(item_slot: PlaceableItemSlot, placed_item: PlaceableItem) -> void:
	var coords_added: Array[Vector2i] = _get_needed_item_coords(item_slot)
	item_slot.placed_item_tile_coords = coords_added
	_occupied_item_tiles += coords_added
	
func _on_item_slot_item_removed(item_slot: PlaceableItemSlot, placed_item: PlaceableItem) -> void:
	# TODO:
	pass
