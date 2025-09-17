extends Node

signal chirp_finished

@export var animated_sprite: AnimatedSprite2D

var parent: Node2D

func _ready() -> void:
	parent = get_parent()
	animated_sprite.animation_finished.connect(_on_animation_finished)

func handle_animation(direction: String) -> void:
	var parent_state: String = parent.state
	match parent_state:
		"idle": animated_sprite.play("idle_" + direction)
		"flying": animated_sprite.play("fly_" + direction)
		"chirping": animated_sprite.play("chirp_" + direction)
		"takeoff": animated_sprite.play("takeoff_" + direction)

func _physics_process(_delta: float) -> void:
	var parent_direction: String = parent.direction
	handle_animation(parent_direction)

func _on_animation_finished() -> void:
	if animated_sprite.animation.begins_with("chirp_"):
		chirp_finished.emit()
