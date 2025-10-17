class_name MoveUpAndDown
extends Node

@export var parent: Node
@export var amplitude: float = 1.0
@export var period: float = 2.0   # full up+down in seconds

var _base: Vector2
var _t: float = 0.0

func _ready() -> void:
	_base = parent.position

func _process(delta: float) -> void:
	_t += delta
	var phase: float = (TAU * _t) / period
	parent.position = Vector2(_base.x, _base.y + sin(phase) * amplitude)
