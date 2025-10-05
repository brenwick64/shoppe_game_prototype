class_name Task
extends Node

@export var iterations: int = 1
@export var time_between_subtasks_sec: float = 0.25
@export var retry_wait_time_sec: float = 0.5

@onready var subtask_timer: Timer = $SubtaskTimer
@onready var retry_timer: Timer = $RetryTimer

signal completed(task: Task)
signal failed(task: Task)

# variables
var adventurer: Adventurer
var subtasks: Array[SubTask]
var task_finished: bool = false
var task_failed: bool = false

# private variables
var _current_iterations: int = 0
var _current_subtask: SubTask
var _current_subtask_index: int = 0
var _total_subtasks: int = 0

# timer locks
var _next_subtask_lock: bool = false
var _retry_timer_lock: bool = true

## -- overrides --
func _ready() -> void:
	for child: Node in get_children():
		if child is not SubTask: continue
		child.completed.connect(_on_subtask_completed)
		child.failed.connect(_on_subtask_failed)
		subtasks.append(child)
	_total_subtasks = subtasks.size()
	subtask_timer.timeout.connect(_on_subtask_timer_timeout)
	retry_timer.timeout.connect(_on_retry_timer_timeout)


## -- public methods --
func init(p_adventurer: Adventurer) -> void:
	adventurer = p_adventurer

func on_physics_process(delta: float) -> void:
	if task_finished: return
	if task_failed: return
	if not _current_subtask:
		_next_subtask(self, {})
	else:
		# handle current subtask
		if _next_subtask_lock: return
		_current_subtask.on_physics_process(delta)


## -- helper functions --
func _next_subtask(parent_task: Task, payload: Dictionary) -> void:
	if _current_subtask_index >= _total_subtasks:
		_current_iterations += 1
		_check_finished()
		return
	_current_subtask = subtasks[_current_subtask_index]
	_current_subtask.init(self, payload)
	# invoke delay before subtask
	_next_subtask_lock = true
	subtask_timer.start(time_between_subtasks_sec)
	print("running subtask: " + _current_subtask.name)

func _check_finished() -> void:
	if _current_iterations >= iterations:
		_complete_task()
	else:
		_current_subtask = null
		_current_subtask_index = 0

func _handle_retry_subtask(subtask: SubTask, payload: Dictionary) -> void:
	if subtask.current_retries >= subtask.max_retries:
		_fail_subtask()
		return
	# start timer
	elif _retry_timer_lock and retry_timer.time_left <= 0:
			retry_timer.start(retry_wait_time_sec)
	# wait for timer
	elif _retry_timer_lock: return
	# reset state and run subtask again
	_current_subtask = null
	_retry_timer_lock = true
	subtask.current_retries += 1
	print("retrying subtask: " + subtask.name + " retries: " + str(subtask.current_retries))
	_next_subtask(self, payload)

func _handle_retry_task() -> void:
	print("retrying task: " + self.name)
	for subtask: SubTask in subtasks:
		subtask.reset_state()
	_current_subtask_index = 0
	_current_subtask = null

func _handle_kill_task() -> void:
	print("task failed.")
	_fail_task()

func _fail_subtask() -> void:
	print("too many retries, scrapping task!")
	_fail_task()

func _complete_task() -> void:
	task_finished = true
	_current_subtask = null
	_current_subtask_index = 0
	completed.emit(self)

func _fail_task() -> void:
	task_failed = true
	failed.emit(self)

## -- signals --
func _on_subtask_completed(payload: Dictionary) -> void:
	_current_subtask_index += 1
	_next_subtask(self, payload)

func _on_subtask_failed(subtask: SubTask, prev_payload: Dictionary, strategy: String) -> void:
	match strategy:
		"retry_subtask": _handle_retry_subtask(subtask, prev_payload)
		"retry_task": _handle_retry_task()
		"kill_task": _handle_kill_task()
		_: pass

func _on_subtask_timer_timeout() -> void:
	_next_subtask_lock = false

func _on_retry_timer_timeout() -> void:
	_retry_timer_lock = false
