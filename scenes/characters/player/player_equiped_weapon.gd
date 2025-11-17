class_name PlayerEquippedWeaponManager
extends Node2D

@export var player: Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var test_weapon: Node2D = $WeaponPivot/TestWeapon

var _last_mouse_side: String

func _physics_process(delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var mouse_side: String = _get_mouse_side(player.global_position, mouse_pos)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if test_weapon.is_attacking: return
		
		var mouse_pos: Vector2 = get_global_mouse_position()
		var direction_str: String = _get_mouse_side(player.global_position, mouse_pos)
		test_weapon.start_attack()
		animation_player.play("stab_" + direction_str)


func _get_mouse_side(player_pos: Vector2, mouse_pos: Vector2) -> String:
	var mouse_distance_from_player: Vector2 = player_pos - mouse_pos
	return "right" if mouse_distance_from_player.x < 0 else "left"


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	test_weapon.end_attack	()
