class_name Player
extends CharacterBody2D

@export var tile_manager: TileManager

@export var player_input_component: PlayerInputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var movement_sound: LoopSoundComponent

func _ready() -> void:
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF

func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = player_input_component.get_input_direction()
	animation_component.handle_movement(input_direction)
	movement_component.handle_movement(input_direction, delta)

func _on_animation_component_animation_state_changed(state: String) -> void:
	if state == "moving":
		movement_sound.play_loop()
	elif state == "idle":
		movement_sound.stop_loop()

func _on_movement_component_moveable_moved(_new_position: Vector2) -> void:
	tile_manager.get_terrain_type_from_global_pos(global_position)
