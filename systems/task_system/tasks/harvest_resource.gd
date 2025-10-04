class_name HarvestResource
extends Task

@export var time_between_subtasks: float = 0.5
@export var harvestable_type: String = "tree"
@export var amount: int = 4

@onready var subtask_timer: Timer = $SubtaskTimer

var subtasks: Array[SubTask]
var is_finished: bool = false

var _current_subtask: SubTask
var _current_subtask_index: int = 0
var _total_subtasks: int = 0
var _next_subtask_lock: bool = false

func _ready() -> void:
	for child: Node in get_children():
		if child is not SubTask: continue
		child.completed.connect(_on_subtask_completed)
		subtasks.append(child)
	_total_subtasks = subtasks.size()
	subtask_timer.timeout.connect(_on_subtask_timer_timeout)


## -- public methods --
func on_physics_process(delta: float) -> void:
	if is_finished: return
	if not _current_subtask:
		_next_subtask(self, {})
	else:
		# handle current subtask
		if _next_subtask_lock: return
		_current_subtask.on_physics_process(delta)

	
## -- helper functions --
func _next_subtask(parent_task: Task, payload: Dictionary) -> void:
	if _current_subtask_index >= _total_subtasks:
		_complete_task()
		return
	_current_subtask = subtasks[_current_subtask_index]
	_current_subtask.init(self, payload)
	# invoke delay before subtask
	_next_subtask_lock = true
	subtask_timer.start(time_between_subtasks)

func _complete_task() -> void:
	is_finished = true
	_current_subtask = null
	_current_subtask_index = 0
	completed.emit()


## -- signals --
func _on_subtask_completed(payload: Dictionary) -> void:
	_current_subtask_index += 1
	_next_subtask(self, payload)

func _on_subtask_timer_timeout() -> void:
	_next_subtask_lock = false
