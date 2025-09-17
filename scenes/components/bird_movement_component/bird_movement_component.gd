class_name BirdMovementComponent
extends Node

signal perch_finished
signal takeoff_finished

@export var max_speed: float = 110.0
@export var acceleration: float = 400.0
@export var takeoff_height: float = 50.0   # pixels to climb

var parent: Node2D
var perch: Node2D

var _current_speed: float = 0.0
var _target_altitude: float
var _taking_off: bool = false

func _ready() -> void:
	parent = get_parent()

func _fly(delta: float) -> void:
	var direction_vector: Vector2 =  Vector2.LEFT if parent.direction == "left" else Vector2.RIGHT
	parent.position += direction_vector.normalized() * max_speed * delta

func _land(delta: float) -> void:
	if not perch: return
	var distance_to_perch: float = parent.global_position.distance_to(perch.global_position)
	if distance_to_perch < parent.perch_seated_distance_px:
		perch_finished.emit()
	# fly towards perch
	var direction_to_perch: Vector2 = (perch.global_position - parent.global_position).normalized()
	parent.position += direction_to_perch.normalized() * max_speed * delta

func _start_takeoff() -> void:
	_taking_off = true
	_current_speed = 0.0
	_target_altitude = parent.position.y - takeoff_height

func _takeoff(delta: float) -> void:
	if not _taking_off:
		_start_takeoff()
	
	_current_speed = min(_current_speed + acceleration * delta, max_speed)
	var direction_vector: Vector2 = Vector2.LEFT if parent.direction == "left" else Vector2.RIGHT
	
	var vertical: float = -1.0 if parent.position.y > _target_altitude else 0.0
	parent.position += Vector2(
		direction_vector.x, 
		vertical
	).normalized() * _current_speed * delta

	# Stop takeoff once we’ve climbed enough
	if parent.position.y <= _target_altitude:
		_taking_off = false
		takeoff_finished.emit()

func _physics_process(delta: float) -> void:
	var parent_state: String = get_parent().state
	match parent_state:
		"flying": _fly(delta)
		"landing": _land(delta)
		"takeoff": _takeoff(delta)
