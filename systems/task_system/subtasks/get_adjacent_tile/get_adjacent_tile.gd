extends SubTask

@export var input_var_name: String
@export var output_var_name: String
@export var target_layer_name: String = "Grass"

func on_physics_process(delta: float) -> void:
	super.on_physics_process(delta)
	var adjacent_tile: Vector2 = _get_adjacent_tile_gp()
	if adjacent_tile:
		payload.merge({ output_var_name: adjacent_tile })
		super.complete(payload)
	else:
		super.fail(self, payload, "retry_subtask")


## -- main function --
func _get_adjacent_tile_gp() -> Vector2:
	var target_node: Node2D = payload[input_var_name]
	var positions: Array[Vector2] = GlobalTileManager.get_adjacent_ground_tiles_gp(
		target_node.global_position, 
		target_layer_name, 
		["navigatable", "unobstructed"]
	)
	#TODO: add options for non-random?
	#TODO: bugs out if potitions is empty
	var adjacent_tile_gp: Vector2 = positions.pick_random()
	return adjacent_tile_gp
