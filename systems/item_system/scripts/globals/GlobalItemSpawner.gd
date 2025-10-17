## GlobalItemSpawner.gd
extends Node

@onready var coin_scene: PackedScene = preload("res://scenes/objects/coin/coin.tscn")

## -- public methods --
func spawn_item_pickup(
	item_id: int, 
	count: int,
	start_pos: Vector2, 
	end_pos: Vector2,
	pickup_owner: Node2D = null,
	) -> ItemPickup:
		
	var spawned_items: Node2D = _get_spawned_items()
	if not spawned_items: return
	var item_data: RItemData = _get_item_data(item_id)
	if not item_data: return
	
	var pickup_ins: ItemPickup = item_data.new_pickup()
	pickup_ins.count = count
	pickup_ins.global_position = start_pos
	pickup_ins.start_pos = start_pos
	pickup_ins.end_pos = end_pos
	if pickup_owner:
		pickup_ins.owner_id = pickup_owner.get_instance_id()
	spawned_items.add_child(pickup_ins)
	return pickup_ins

func spawn_coins(start_pos: Vector2, item_price: int) -> void:
	var coin_count: int = min(item_price, 5)
	for i: int in range(coin_count):
		var random_dist: int = randi_range(-10, 10)
		var max_rotation_deg_left = 45
		var max_rotation_deg_right = 135
		const ROTATION_SCALAR: float = 4.5 # the mapping of degrees to 10
		var end_pos: Vector2 = start_pos + Vector2(random_dist, 0)
		var coin_ins: Node2D = coin_scene.instantiate()
		coin_ins.global_position = start_pos
		coin_ins.start_pos = start_pos
		coin_ins.end_pos = end_pos
		coin_ins.rotation_degrees = 90 + (random_dist * ROTATION_SCALAR)
		
		await get_tree().create_timer(0.05).timeout
		get_tree().root.add_child(coin_ins)


## -- helper functions
func _get_spawned_items() -> Node2D:
	var spawned_items: Node2D = get_tree().get_first_node_in_group("spawned_items")
	if not spawned_items:
		push_error("GlobalItemSpawner error: no spawned_items node found in tree.")
	return spawned_items

func _get_item_data(item_id: int) -> RItemData:
	var item: RItemData = GlobalItemDb.get_item_by_id(item_id)
	if not item:
		push_error("GlobalItemSpawner error: no spawned_items node found in tree.")
	return item
