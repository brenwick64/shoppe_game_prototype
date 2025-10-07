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
	var next_task: Task = current_tasks.get_next_task()
	if not next_task: 
		transition.emit("aquiretask")
	else:
		#TODO: this should be connected ONCE to current tasks (Renamed to task manager)
		_current_task = next_task
		_current_task.completed.connect(_on_task_completed)
		_current_task.failed.connect(_on_task_failed)
		_current_task.init(parent)

func _on_exit() -> void:
	pass

func _on_task_completed(task: Task) -> void:
	task.queue_free()
	_current_task = null
	transition.emit("idle")

func _on_task_failed(task: Task) -> void:
	task.queue_free()
	_current_task = null
	transition.emit("idle")	
