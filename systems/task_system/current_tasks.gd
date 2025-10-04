class_name CurrentTasks
extends Node

func get_tasks() -> Array[Task]:
	var tasks: Array[Task] = []
	for node: Node in get_children():
		if node is Task:
			tasks.append(node)
	return tasks
