extends SubTask

@export var input_var_name: String

## state variables
var _target_pickup: ItemPickup
var _path_traversed: bool = false
var _pickup_aquired: bool = false

## -- overrides --
func init(p_parent_task: Task, p_payload: Dictionary) -> void:
	super.init(p_parent_task, p_payload)
	_target_pickup = payload[input_var_name]
	_target_pickup.picked_up.connect(_on_pickup_picked_up)

func on_physics_process(delta: float) -> void:
	super.on_physics_process(delta)
	# case 1 - no pickup, path not traversed
	if not _path_traversed:
		_traverse_path()
	# case 2 - no pickup, path traversed.
	elif _path_traversed and not _pickup_aquired:
		super.fail(self, payload, "retry_task")
	# case 3 - pickup and path traversed
	elif _pickup_aquired and _path_traversed:
		parent_task.adventurer.current_direction = Vector2.ZERO
		super.complete(payload, reset_state)
	# case 4 - unexpected behavior
	else:
		super.fail(self, payload, "kill_task")

func reset_state() -> void:
	_target_pickup = null
	_pickup_aquired = false
	_path_traversed = false


## -- main function --
func _traverse_path() -> void:
	if not parent_task.adventurer.nav_agent.is_target_reached():
		var direction: Vector2 = parent_task.adventurer.to_local(
			parent_task.adventurer.nav_agent.get_next_path_position()
		).normalized()
		parent_task.adventurer.current_direction = direction
	else:
		_path_traversed = true
		parent_task.adventurer.current_direction = Vector2.ZERO


## -- signals --
func _on_pickup_picked_up() -> void:
	_pickup_aquired = true
