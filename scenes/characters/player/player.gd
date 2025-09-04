class_name Player
extends CharacterBody2D

@export var player_input_component: PlayerInputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent

func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = player_input_component.get_input_direction()
	animation_component.handle_movement(input_direction)
	movement_component.handle_movement(input_direction, delta)
