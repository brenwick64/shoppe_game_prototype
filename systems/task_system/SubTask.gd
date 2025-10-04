class_name SubTask
extends Node

@export var max_retries: int = 0

@warning_ignore("unused_signal")
signal completed(payload: Dictionary)
@warning_ignore("unused_signal")
signal failed(subtask: SubTask, strategy: String)

var parent_task: Task
var payload: Dictionary
var is_active: bool = false
var current_retries: int = 0

func init(p_parent_task: Task, p_payload: Dictionary) -> void:
	parent_task = p_parent_task
	payload = p_payload
	is_active = true

func reset_state() -> void:
	pass

func complete(p_payload, p_reset_state: Callable = func(): return) -> void:
	is_active = false
	completed.emit(p_payload)
	if p_reset_state:
		p_reset_state.call()

func fail() -> void:
	is_active = false

func on_physics_process(_delta: float) -> void:
	if not is_active: return
