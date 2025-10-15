extends SubTask

@export var input_var_name: String

func init(p_parent_task: Task, p_payload: Dictionary) -> void:
	super.init(p_parent_task, p_payload)
	var quest: Quest = p_payload[input_var_name]
	var parent_task_manager: TaskManager = parent_task.adventurer.task_manager
	if not quest or not parent_task_manager:
		super.fail(self, payload, "kill_task")
	_assign_tasks(quest, parent_task_manager)
	super.complete(payload)


## -- helper functions --
func _assign_tasks(quest: Quest, task_manager: TaskManager) -> void:
	for task: Task in quest.quest_steps:
		task_manager.add_task(task)
