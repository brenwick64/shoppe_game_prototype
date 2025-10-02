extends State

@export var idle_time_range_sec: Vector2 = Vector2(5.0, 25.0)
@export var parent: Node2D
@export var animated_sprite_2d: AnimatedSprite2D

@onready var idle_timer: Timer = $IdleTimer

## -- overrides --
func _ready() -> void:
	var random_time: float = randf_range(idle_time_range_sec.x, idle_time_range_sec.y)
	idle_timer.timeout.connect(_on_idle_timer_timeout)
	idle_timer.start(random_time)

func _on_enter() -> void:
	animated_sprite_2d.play("idle_" + parent.direction_name)

func _on_exit() -> void:
	animated_sprite_2d.stop()


## -- signals --
func _on_idle_timer_timeout() -> void:
	transition.emit("roaming")
