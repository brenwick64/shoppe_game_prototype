extends SubTask

@export var stuck_time_threshold_sec: float = 60.0
@export var stuck_timer: Timer

## state variables
var _path_traversed: bool = false

## -- overrides --
func _ready() -> void:
	stuck_timer.timeout.connect(_on_stuck_timer_timeout)

func init(p_parent_task: Task, p_payload: Dictionary) -> void:
	super.init(p_parent_task, p_payload)
	stuck_timer.start(stuck_time_threshold_sec)

func on_physics_process(delta: float) -> void:
	super.on_physics_process(delta)
	if not _path_traversed:
		_traverse_path()
	else:
		super.complete(payload, reset_state)

func reset_state() -> void:
	_path_traversed = false


## -- main function --
func _traverse_path() -> void:
	if not parent_task.adventurer.nav_agent.is_target_reached():
		var direction: Vector2 = parent_task.adventurer.to_local(
			parent_task.adventurer.nav_agent.get_next_path_position()
		).normalized()
		parent_task.adventurer.current_direction = direction
	else:
		parent_task.adventurer.current_direction = Vector2.ZERO
		_path_traversed = true


## -- signals --
func _on_stuck_timer_timeout() -> void:
	super.fail(self, payload, "retry_task")
