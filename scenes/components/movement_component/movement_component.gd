class_name MovementComponent
extends Node

signal moveable_moved(new_position: Vector2)
signal moveable_stopped()

@export_category("Behavior Settings")
@export var move_threshold_px: int = 5
@export var stop_threshold_sec: float = 0.2
@export var pixel_smoothing: bool = true
@export_category("Movement Settings")
@export var SPEED: float = 100

var moveable_parent: CharacterBody2D
var _last_position: Vector2
var _time_since_moved: float = 0.0
var _stopped_emitted: bool = false

func _ready() -> void:
	var parent: Node = get_parent()
	if parent is CharacterBody2D:
		moveable_parent = parent
		_last_position = moveable_parent.global_position

func _check_movement(delta: float) -> void:
	var distance_moved: float = moveable_parent.global_position.distance_to(_last_position)
	
	if distance_moved >= move_threshold_px: # parent moved
		moveable_moved.emit(moveable_parent.global_position)
		_last_position = moveable_parent.global_position
		_time_since_moved = 0.0
		_stopped_emitted = false
	else: # parent hasn't moved
		_time_since_moved += delta
		if _time_since_moved >= stop_threshold_sec and not _stopped_emitted:
			moveable_stopped.emit()
			_stopped_emitted = true

func handle_movement(direction: Vector2, delta: float) -> void:
	if not moveable_parent: return
	moveable_parent.velocity = direction.normalized() * SPEED
	moveable_parent.move_and_slide()
	if pixel_smoothing:
		moveable_parent.global_position = moveable_parent.global_position.round()
	_check_movement(delta)
