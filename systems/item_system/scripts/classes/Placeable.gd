class_name Placeable
extends Node2D

@export var place_sound: SingleSoundComponent

var item_id: int
var dimensions: Vector2i
var is_loaded_in: bool = false

func _ready() -> void:
	# avoids playing the placed sound each time objects are loaded
	if is_loaded_in: return
	
	place_sound.play_sound()
