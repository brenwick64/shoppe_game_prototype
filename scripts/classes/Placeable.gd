class_name Placeable
extends StaticBody2D

@onready var placed_sound: SingleSoundComponent = $PlacedSound

var item_id: int
var dimensions: Vector2i
var origin_tile_coords: Vector2i

func _ready() -> void:
	placed_sound.play_sound()
