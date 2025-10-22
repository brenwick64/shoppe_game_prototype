class_name Interactable
extends Area2D

signal interacted(interactor: Node2D)
signal focus_changed(is_focused: bool)

@export var has_interactable_menu: bool = false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

## -- public methods --
func interact(interactor: Interactor) -> void:
	interacted.emit(interactor)

func set_focus() -> void:
	focus_changed.emit(true)

func unset_focus() -> void:
	focus_changed.emit(false)

func disable_collision() -> void:
	if collision_shape:
		collision_shape.disabled = true

func enable_collision() -> void:
	if collision_shape:
		collision_shape.disabled = false
