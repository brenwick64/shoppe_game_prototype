extends SubTask

@export var input_var_name: String
@export var output_var_name: String

func on_physics_process(delta: float) -> void:
	super.on_physics_process(delta)
	payload.merge({ output_var_name: _get_adjacent_tile_gp() })
	super.complete(payload)


## -- main function --
func _get_adjacent_tile_gp() -> Vector2:
	var target_node: Node2D = payload[input_var_name]
	# TODO: fail subtask
	if not target_node: pass
	var positions: Array[Vector2] = GlobalTileManager.get_adjacent_ground_tiles_gp(
		target_node.global_position, 
		"Grass", 
		["navigatable", "unobstructed"]
	)
	# TODO: fail subtask
	if not positions: pass
	var adjacent_tile_gp: Vector2 = positions[0]
	return adjacent_tile_gp
