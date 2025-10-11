extends State

@export var parent: Node2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var takeoff_height: float = 60.0   # pixels to climb

var _is_taking_off: bool = false
var _current_speed: float = 0.0
var _target_altitude: float = 50.0

## -- helper functions --
func _start_takeoff() -> void:
	_is_taking_off = true
	_current_speed = 0.0
	_target_altitude = parent.position.y - takeoff_height

func _takeoff(delta: float) -> void:
	if not _is_taking_off: _start_takeoff()

	_current_speed = min(
		(_current_speed + parent.takeoff_acceleration * delta), 
		parent.max_speed
	)
	var direction_vector: Vector2 = Vector2.LEFT if parent.direction_name == "left" else Vector2.RIGHT
	var vertical: float = clamp((_target_altitude - parent.position.y) * 0.1, -1.0, 0.0)

	parent.position += Vector2(
		direction_vector.x,
		vertical
	).normalized() * _current_speed * delta
	
	if parent.position.y - _target_altitude < 1:
		transition.emit("despawning")

## -- overrides
func _on_physics_process(delta: float) -> void:
	_takeoff(delta)

func _on_enter() -> void:
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
	animated_sprite_2d.play("takeoff_" + parent.direction_name)

func _on_exit() -> void:
	animated_sprite_2d.animation_finished.disconnect(_on_animation_finished)
	animated_sprite_2d.stop()

## -- signals --
func _on_animation_finished() -> void:
	if animated_sprite_2d.animation.begins_with("takeoff_"):
		animated_sprite_2d.play("fly_" + parent.direction_name)
