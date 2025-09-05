class_name AnimationComponent
extends Node

signal animation_state_changed(state: String)

var moveable_parent: CharacterBody2D
var animated_sprite: AnimatedSprite2D
var last_direction_name: String = "down"

var _current_state: String

func _ready() -> void:
	var parent: Node = get_parent()
	if parent is not CharacterBody2D:
		push_error("AnimationComponent error: parent is not type CharacterBody2D")
		return
	var sprite: Node = parent.get_node_or_null("AnimatedSprite2D")
	if sprite is not AnimatedSprite2D:
		push_error("AnimationComponent error: parent has no AnimatedSprite2D")
		return
	moveable_parent = parent
	animated_sprite = sprite

func _get_direction_name(direction: Vector2) -> String:
	if direction == Vector2.ZERO:
		return "none"
	# Pick whichever axis has the strongest component
	if abs(direction.x) > abs(direction.y):
		return "right" if direction.x > 0 else "left"
	else:
		return "down" if direction.y > 0 else "up"

func handle_movement(direction: Vector2) -> void:
	if not moveable_parent or not animated_sprite: return
	
	var direction_name: String = _get_direction_name(direction)
	if direction_name == "none":
		if _current_state != "idle":
			animation_state_changed.emit("idle")
		animated_sprite.play("idle_" + last_direction_name)
	else:
		if _current_state != "moving":
			animation_state_changed.emit("moving")
		last_direction_name = direction_name
		animated_sprite.play("move_" + last_direction_name)
