class_name HealthComponent
extends Node

signal health_depleted

@export var max_health: int = 10

var _current_health: int

func  _ready() -> void:
	reset_health()

func _check_depleted() -> void:
	if _current_health <= 0:
		health_depleted.emit()

func remove_health(health: int) -> void:
	_current_health = max(_current_health - health, 0)
	_check_depleted()

func add_health(health: int) -> void:
	_current_health = min(_current_health + health, max_health)

func reset_health() -> void:
	_current_health = max_health
