extends State

@export var parent: Adventurer
@export var animated_sprite_2d: AnimatedSprite2D

@export var current_tasks: CurrentTasks

var _current_task: Task

func _on_enter() -> void:
	parent.current_direction = Vector2.ZERO

func _on_physics_process(delta: float) -> void:
	if _current_task:
		_current_task.on_physics_process(delta)
		return
	# pull next task
	var task_list: Array[Task] = current_tasks.get_tasks()
	if not task_list: 
		transition.emit("aquiretask")
	else:
		_current_task = task_list[0]
		_current_task.init(parent)

func _on_exit() -> void:
	pass
