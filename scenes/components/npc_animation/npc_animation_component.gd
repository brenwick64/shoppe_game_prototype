class_name NPCAnimationComponent
extends Node

signal animation_finished

@export var animated_sprite: AnimatedSprite2D

var last_direction_name: String = "down"
var is_animation_locked: bool = false

func _get_direction_name(input_direction: Vector2) -> String:
	if input_direction == Vector2.ZERO:
		return last_direction_name # Maintain last direction on idle
	if abs(input_direction.x) > abs(input_direction.y):
		return "right" if input_direction.x > 0 else "left"
	else:
		return "down" if input_direction.y > 0 else "up"
		
func _animate_idle() -> void:
	animated_sprite.play("idle_" + last_direction_name)
	
func _animate_movement(direction: Vector2) -> void:
	var current_direction_name: String = _get_direction_name(direction)
	animated_sprite.play("walk_" + current_direction_name)
	last_direction_name = current_direction_name

func handle_animation(direction: Vector2) -> void:
	if is_animation_locked: return
	if direction == Vector2.ZERO:
		_animate_idle()
	else:
		_animate_movement(direction)
