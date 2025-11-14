class_name TestWeapon
extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $HitBox/CollisionShape2D

## -- public methods --
func enable() -> void:
	visible = true
	collision_shape_2d.disabled = false

func disable() -> void:
	visible = false
	collision_shape_2d.disabled = true
