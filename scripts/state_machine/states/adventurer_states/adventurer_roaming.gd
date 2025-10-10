extends State

@export var parent: Node2D
@export var animated_sprite_2d: AnimatedSprite2D

@export var roam_time_sec: float = 2.0
@onready var roaming_timer: Timer = $RoamingTimer

var _is_walking: bool = false

var next_states: Array[String] = ["aquiretask"]

## -- overrides -- 
func _ready() -> void:
	roaming_timer.timeout.connect(_on_roam_walk_timer_timeout)

func _on_enter() -> void:
	_is_walking = false

func _on_exit() -> void:
	roaming_timer.stop() # prevents asynchronous state switching via timeout
	animated_sprite_2d.stop()
	parent.current_direction = Vector2.ZERO

func _on_physics_process(_delta: float) -> void:
	if _is_walking: return # keep walking
	else:
		_is_walking = true
		_set_parent_walk_direction()
		roaming_timer.start(roam_time_sec)


## -- helper functions --
func _set_parent_walk_direction() -> void:
	var directions: Array[Vector2] = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	parent.current_direction = directions.pick_random()


## -- signals --
func _on_roam_walk_timer_timeout() -> void:
	var next_state: String = next_states.pick_random()
	transition.emit(next_state)
