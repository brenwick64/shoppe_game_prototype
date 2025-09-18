extends State

@export var parent: Node2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var next_state_name: String

## -- helper functions --
func _move_toward_bird_area(bird_area: Area2D, delta: float) -> void:
	var direction_to_bird_area: Vector2 = (bird_area.global_position - parent.global_position).normalized()
	parent.position += direction_to_bird_area.normalized() * parent.max_speed * delta

func _land(delta: float) -> void:
	if not parent.target_bird_area: return
	
	var distance_to_perch: float = parent.global_position.distance_to(parent.target_bird_area.global_position)
	
	if distance_to_perch < 1.0: # arrive at perch
		transition.emit(next_state_name)
	elif distance_to_perch < 10.0: # close enough to play landing animation
		animated_sprite_2d.play("land_" + parent.direction_name)
		_move_toward_bird_area(parent.target_bird_area, delta)
	else: # keep flying
		_move_toward_bird_area(parent.target_bird_area, delta)

## -- overrides
func _on_physics_process(delta: float) -> void:
	_land(delta)

func _on_enter() -> void:
	animated_sprite_2d.play("fly_" + parent.direction_name)

func _on_exit() -> void:
	animated_sprite_2d.stop()
