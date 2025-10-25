class_name CraftingProgressBar
extends Control

@onready var cog_wheel: TextureRect = $CogWheel

@export var cog_rotation_speed: float = 180.0 # degrees per second


var _cog_angle: float = 0.0


func _process(delta: float) -> void:
	_spin_cog(delta)


## -- helper functions --
func _spin_cog(delta: float) -> void:
	_cog_angle += cog_rotation_speed * delta
	_cog_angle = fmod(_cog_angle, 360.0)
	cog_wheel.rotation_degrees = _cog_angle
