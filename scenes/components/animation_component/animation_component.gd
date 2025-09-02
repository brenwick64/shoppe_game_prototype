class_name AnimationComponent
extends Node

@export var animated_sprite: AnimatedSprite2D

var last_direction: String = "south"

func _get_direction_from_vector(vector: Vector2) -> String:
	# Small deadzone for near-zero vectors
	if vector.length_squared() < 0.000001:
		return "none"

	var angle: float = vector.angle()                # [-π, π]
	var sector_size: float = TAU / 8.0               # 45 degrees
	var a: float = fposmod(angle, TAU)               # [0, 2π)
	var idx: int = int(round(a / sector_size)) % 8   # 0..7

	var names: Array[String] = [
		"east", "southeast", "south", "southwest",
		"west", "northwest", "north", "northeast"
	]
	return names[idx]

func handle_animation(movement_vector: Vector2) -> void:
	var direction_name: String = _get_direction_from_vector(movement_vector)
	if direction_name != "none":
		last_direction = direction_name
	if movement_vector == Vector2.ZERO:
		animated_sprite.play("idle_" + last_direction)
	else:
		animated_sprite.play("run_" + last_direction)
