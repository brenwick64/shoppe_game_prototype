extends Node2D

@export var spawn_radius: int = 200

@onready var firefly_scene: PackedScene = preload("res://scenes/characters/firefly/firefly.tscn")

func _on_spawn_timer_timeout() -> void:
	var new_x = global_position.x + randf_range(-spawn_radius, spawn_radius)
	var new_y = global_position.y + randf_range(-spawn_radius, spawn_radius)
	var ins = firefly_scene.instantiate()
	ins.global_position = Vector2(new_x, new_y)
	get_tree().root.add_child(ins)
