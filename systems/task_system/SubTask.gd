class_name SubTask
extends Node

signal completed(payload: Dictionary)

var parent_task: Task
var payload: Dictionary
var is_active: bool = false

func init(p_parent_task: Task, p_payload: Dictionary) -> void:
	parent_task = p_parent_task
	payload = p_payload
	is_active = true

func complete(payload) -> void:
	is_active = false
	completed.emit(payload)

func on_physics_process(delta: float) -> void:
	if not is_active: return
