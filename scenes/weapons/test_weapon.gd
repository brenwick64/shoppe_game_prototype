class_name TestWeapon
extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $HitBox/CollisionShape2D
@onready var attack_sound: OneShotSoundComponent = $AttackSound

var is_attacking: bool = false

## -- public methods --
func start_attack() -> void:
	is_attacking = true
	_show_weapon()
	attack_sound.play_sound()

func end_attack() -> void:
	_hide_weapon()
	is_attacking = false


## -- helper functions --
func _show_weapon() -> void:
	visible = true
	collision_shape_2d.disabled = false
	
func _hide_weapon() -> void:
	visible = false
	collision_shape_2d.disabled = true
