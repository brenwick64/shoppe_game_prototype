extends SubTask

@export var input_var_name: String


func on_physics_process(delta: float) -> void:
	super.on_physics_process(delta)
	_face_target()
	super.complete(payload)


## -- main function --
func _face_target() -> void:
	var target_node: Variant = payload[input_var_name]
	if not is_instance_valid(target_node): 
		failed.emit(self, payload, "retry_task")
		return
	parent_task.adventurer.npc_animation_component.last_direction_name = _get_direction_facing_target(
		parent_task.adventurer,
		target_node
	)

## -- helper functions --
func _get_direction_facing_target(parent_node: Node2D, target_node: Node2D) -> String:
	var direction = target_node.global_position - parent_node.global_position
	# Determine the dominant direction
	if abs(direction.x) > abs(direction.y):
		return "right" if direction.x > 0 else "left"
	else:
		return "down" if direction.y > 0 else "up"
