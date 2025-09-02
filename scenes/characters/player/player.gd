extends CharacterBody2D

@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent

func get_movement_vector() -> Vector2:
	# Handles cases of digital and analog player inputs (keyboard = digital, controller = analog)
	var x_movement: float = Input.get_action_strength("move_east") - Input.get_action_strength("move_west")
	var y_movement: float = Input.get_action_strength("move_south") - Input.get_action_strength("move_north")
	
	var raw_vector: Vector2 = Vector2(x_movement, y_movement)

	if raw_vector == Vector2.ZERO:
		return Vector2.ZERO

	# Normalize and snap to one of 8 directions
	var angle: float = raw_vector.angle()
	var snapped_angle: float = round(angle / (PI / 4.0)) * (PI / 4.0)
	return Vector2.RIGHT.rotated(snapped_angle)

func _physics_process(delta: float) -> void:
	var movement_vector: Vector2 = get_movement_vector()
	movement_component.handle_movement(movement_vector, delta, 1)
	animation_component.handle_animation(movement_vector)
