class_name Player
extends CharacterBody2D

@export var tile_manager: TileManager

@export var player_input_component: PlayerInputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var movement_sound: MovementSoundComponent

var _current_terrain: String

func _ready() -> void:
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF

func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = player_input_component.get_input_direction()
	animation_component.handle_movement(input_direction, delta)
	movement_component.handle_movement(input_direction, delta)

func _on_animation_component_animation_state_changed(state: String) -> void:
	if state == "moving":
		movement_sound.play_loop()
	elif state == "idle":
		movement_sound.stop_loop()

func _on_movement_component_moveable_moved(_new_position: Vector2) -> void:
	var terrain_type: String = tile_manager.get_cust_meta_from_global_pos(
		global_position,
		"terrain_type"
	)
	if terrain_type != _current_terrain:
		var new_track: Array[AudioStream] = GlobalAudioManager.get_audio_track("move_" + terrain_type)
		movement_sound.switch_tracks(new_track)
		_current_terrain = terrain_type
