class_name MovementComponent
extends Node

@export var SPEED: float = 100

var moveable_parent: CharacterBody2D

func _ready() -> void:
	var parent: Node = get_parent()
	if parent is CharacterBody2D:
		moveable_parent = parent

func handle_movement(direction: Vector2, delta: float) -> void:
	if not moveable_parent: return
	moveable_parent.velocity = direction.normalized() * SPEED
	moveable_parent.move_and_slide()
