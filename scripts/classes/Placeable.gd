class_name Placeable
extends StaticBody2D

@onready var placed_sound: SingleSoundComponent = $PlacedSound


func _ready() -> void:
	placed_sound.play_sound()
