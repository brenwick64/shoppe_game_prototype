class_name QuestCrate
extends StaticBody2D

@export var sprite: Sprite2D
@onready var navigation_marker: Marker2D = $NavigationMarker
@onready var one_shot_sound_component: OneShotSoundComponent = $OneShotSoundComponent

var items: Array[RInventoryItem]

## -- public methods --
func deposit_items(depositor: Node2D, item_id: int, count: int) -> void:
	var item_index: int = _get_item_index(item_id)
	if item_index == -1:
		_add_inv_item(item_id, count)
	else:
		_update_inv_item(item_index, count)
	_spawn_pickups(item_id, count, depositor.global_position, global_position)
	var item_data: RItemData = GlobalItemDb.get_item_by_id(item_id)
	print(depositor.adventurer_name + " deposited " + str(count) + " x " + item_data.item_name)


## -- helper functions --
func _spawn_pickups(item_id: int, count: int, from_gp: Vector2, to_gp: Vector2) -> void:
	for i: int in range(count):
		await get_tree().create_timer(0.1).timeout
		var spawned_pickup = GlobalItemSpawner.spawn_item_pickup(
			item_id, 
			from_gp,
			to_gp
		)
		spawned_pickup.drop_finished.connect(_on_pickup_drop_finished)

func _get_item_index(item_id: int) -> int:
	for inv_item: RInventoryItem in items:
		if inv_item.item_id == item_id:
			return items.find(inv_item)
	return -1

func _add_inv_item(item_id: int, count: int) -> void:
	var inv_item: RInventoryItem = RInventoryItem.new()
	inv_item.item_id = item_id
	inv_item.count = count
	items.append(inv_item)

func _update_inv_item(item_index: int, count: int) -> void:
	var inv_item: RInventoryItem = items[item_index]
	inv_item.count += count

func _show_outline() -> void:
	var shader_material: ShaderMaterial = sprite.material
	shader_material.set_shader_parameter("width", 0.55)  
	shader_material.set_shader_parameter("pattern", 1)

func _hide_outline() -> void:
	var shader_material: ShaderMaterial = sprite.material
	shader_material.set_shader_parameter("width", 0)
	shader_material.set_shader_parameter("pattern", 1)


## -- signals --
func _on_pickup_drop_finished(item_pickup: ItemPickup) -> void:
	one_shot_sound_component.play_sound()
	item_pickup.queue_free()

func _on_interactable_focus_changed(is_focused: bool) -> void:
	if is_focused: 
		_show_outline()
	else:
		_hide_outline()
