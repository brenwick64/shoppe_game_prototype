class_name CurrentTasks
extends Node

# TODO: these currently dont do anything.
# rework so state machine only communicates with this node
signal task_complete(task: Task)
signal task_failed(task: Task)

#TODO: this runs multiple times re-connecting signals
# find a better solution (update tasks?)
func get_tasks() -> Array[Task]:
	var tasks: Array[Task] = []
	for node: Node in get_children():
		if node is Task:
			node.completed.connect(_on_task_completed)
			node.failed.connect(_on_task_failed)
			tasks.append(node)
	return tasks

func _on_task_completed(task: Task) -> void:
	task.completed.disconnect(_on_task_completed)
	task.failed.disconnect(_on_task_failed)
	task_complete.emit(task)

func _on_task_failed(task: Task) -> void:
	task.completed.disconnect(_on_task_completed)
	task.failed.disconnect(_on_task_failed)
	task_complete.emit(task)
