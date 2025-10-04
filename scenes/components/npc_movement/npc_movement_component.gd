class_name NPCMovementComponent
extends Node

@export var parent: CharacterBody2D
@export var max_speed: int = 25.0

var acceleration:float = 0.0

func handle_movement(direction: Vector2, speed_scalar: float = 1.0):
	var current_speed: float = max_speed * speed_scalar
	if direction != Vector2.ZERO:
		acceleration = clamp(acceleration + 0.1, 0, 1)
	else:
		acceleration = max(acceleration - 0.05, 0) # Smooth deceleration
	parent.velocity = direction * current_speed * acceleration
	parent.move_and_slide()
