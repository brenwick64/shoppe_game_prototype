extends SubTask

@export var input_var_name: String
@export var output_var_name: String

var shoppe_items: ShoppeItems

func on_physics_process(delta: float) -> void:
	super.on_physics_process(delta)
	var target_item: Variant = payload[input_var_name]
	if not is_instance_valid(target_item):
		super.fail(self, payload, "retry_task")
		return
	if not target_item:
		super.fail(self, payload, "retry_subtask")
		return
	var parent_furniture: PlaceableFurniture = _get_parent_shoppe_furniture(target_item)
	if not parent_furniture:
		super.fail(self, payload, "retry_subtask")
		return
	var nearby_tile_positions: Array[Vector2] = _get_furniture_nearby_tiles(parent_furniture)
	if not nearby_tile_positions:
		super.fail(self, payload, "retry_subtask")
		return
	var closest_tile_gp: Vector2 = _get_tile_closest_to_item(nearby_tile_positions, target_item)
	if closest_tile_gp == Vector2.ZERO:
		super.fail(self, payload, "retry_subtask")
		return
	payload.merge({ output_var_name: closest_tile_gp })
	super.complete(payload)


func _get_parent_shoppe_furniture(target_item: PlaceableItem) -> PlaceableFurniture:
	var shoppe_furniture: ShoppeFurniture = get_tree().get_first_node_in_group("shoppe_furniture")
	if not shoppe_furniture:
		return null
	var parent_furniture: PlaceableFurniture = shoppe_furniture.get_furniture_by_unique_id(target_item.furniture_unique_id)
	return parent_furniture

func _get_furniture_nearby_tiles(parent_furniture: PlaceableFurniture) -> Array[Vector2]:
	var shoppe_layer: TileMapLayer = GlobalTileManager.get_tilemap_layer_by_name("ShoppeFloor")
	var viable_adjacent_tile_gps: Array[Vector2] = [] 
		
	for coords: Vector2i in parent_furniture.occupied_tiles:
		var tile_gp: Vector2 = GlobalTileManager.get_global_position_from_tile(shoppe_layer, coords)
		var viable_gps: Array[Vector2] = GlobalTileManager.get_adjacent_ground_tiles_gp(
			tile_gp, 
			"ShoppeFloor", 
			["navigatable", "unobstructed"]
		)
		viable_adjacent_tile_gps += viable_gps
	return viable_adjacent_tile_gps

func _get_tile_closest_to_item(tile_gps: Array[Vector2], target_item: PlaceableItem) -> Vector2:
	var closest_tile_gp: Vector2 = Vector2.ZERO
	var closest_distance: float = INF
	for gp: Vector2 in tile_gps:
		var distance: float = gp.distance_to(target_item.global_position)
		if distance < closest_distance:
			closest_tile_gp = gp
			closest_distance = distance
	return closest_tile_gp


## -- main function --
func _get_random_item() -> PlaceableItem:
	if not shoppe_items: return null
	return shoppe_items.shoppe_items.pick_random()
