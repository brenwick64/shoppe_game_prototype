extends State

@export var idle_time_range_sec: Vector2 = Vector2(5.0, 25.0)
@export var parent: Node2D
@export var animated_sprite_2d: AnimatedSprite2D

@onready var idle_timer: Timer = $IdleTimer

## -- overrides --
func _ready() -> void:
	idle_timer.timeout.connect(_on_idle_timer_timeout)

func _on_enter() -> void:
	parent.current_direction = Vector2.ZERO
	var random_time: float = randf_range(idle_time_range_sec.x, idle_time_range_sec.y)
	idle_timer.start(random_time)

func _on_exit() -> void:
	idle_timer.stop()
	animated_sprite_2d.stop()


## -- signals --
func _on_idle_timer_timeout() -> void:
	transition.emit("roaming")
