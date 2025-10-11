extends State

@export var task_manager: TaskManager

var _aquiring_task: bool = false

func _on_enter() -> void:
	_aquiring_task = false
	task_manager.task_added.connect(_on_task_manager_task_added)

func _on_exit() -> void:
	task_manager.task_added.disconnect(_on_task_manager_task_added)

func _on_physics_process(_delta: float) -> void:
	if not _aquiring_task:
		_aquiring_task = true
		var new_task: Task = GlobalTaskManager.get_new_task()
		task_manager.add_task(new_task)

func _on_task_manager_task_added() -> void:
	transition.emit("performtask")
