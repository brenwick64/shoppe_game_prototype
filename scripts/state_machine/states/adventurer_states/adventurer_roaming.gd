extends State

@export var parent: Node2D
@export var animated_sprite_2d: AnimatedSprite2D

@export var roam_time_sec: float = 1.0
@onready var roaming_timer: Timer = $RoamingTimer

var _is_walking: bool = false


## -- overrides -- 
func _ready() -> void:
	roaming_timer.timeout.connect(_on_roam_walk_timer_timeout)

func _on_enter() -> void:
	_is_walking = false

func _on_exit() -> void:
	roaming_timer.stop() # prevents asynchronous state switching via timeout
	animated_sprite_2d.stop()

func _on_physics_process(delta: float) -> void:
	if _is_walking: 
		_walk(delta)
	else:
		_is_walking = true
		_set_parent_walk_direction()
		roaming_timer.start(roam_time_sec)


## -- helper functions --
func _walk(delta: float) -> void:
	var direction_vector: Vector2
	match parent.direction_name:
		"up": direction_vector = Vector2.UP
		"down": direction_vector = Vector2.DOWN
		"left": direction_vector = Vector2.LEFT
		"right": direction_vector = Vector2.RIGHT
	animated_sprite_2d.play("walk_" + parent.direction_name)
	
	var velocity: Vector2 = direction_vector.normalized() * parent.walk_speed
	parent.velocity = velocity
	parent.move_and_slide()

func _set_parent_walk_direction() -> void:
	var direction_names: Array[String] = ["down", "up", "left", "right"]
	parent.direction_name = direction_names.pick_random()


## -- signals --
func _on_roam_walk_timer_timeout() -> void:
	transition.emit("idle")
