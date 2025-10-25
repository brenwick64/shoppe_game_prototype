class_name UIMenu
extends Control

@export var menu_name: String
@export var open_sound: OneShotSoundComponent
@export var close_sound: OneShotSoundComponent


## -- public methods --
func show_menu(toggled_from: Node2D, toggled_by: Player, play_sound: bool = false) -> void:
	visible = true
	if play_sound:
		open_sound.play_sound()

func hide_menu(play_sound: bool) -> void:
	visible = false
	if play_sound:
		close_sound.play_sound()
