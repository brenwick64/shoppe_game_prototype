class_name CurrentTasks
extends Node

signal task_complete
signal task_failed

func get_next_task() -> Task:
	var task_list: Array[Node] = get_children()
	if not task_list.is_empty(): return task_list[0]
	return null

func add_task(task: Task) -> void:
	task.completed.connect(_on_task_completed)
	task.failed.connect(_on_task_failed)
	add_child(task)

func remove_task(task: Task) -> void:
	task.completed.disconnect(_on_task_completed)
	task.failed.disconnect(_on_task_failed)
	task.queue_free()


## -- signals --
func _on_task_completed(task: Task) -> void:
	remove_task(task)
	task_complete.emit()

func _on_task_failed(task: Task) -> void:
	remove_task(task)
	task_failed.emit()
