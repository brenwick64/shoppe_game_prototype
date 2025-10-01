class_name PlaceablePreview
extends Node2D

@export var sprite: Sprite2D

const REGULAR_MODULATE: Color = Color(1, 1, 1, 0.5)
const BLOCKED_MODULATE: Color = Color(1, 0, 0, 0.75)

var item_id: int
var dimensions: Vector2i
var is_placeable: bool = true

func _ready() -> void:
	sprite.modulate = REGULAR_MODULATE
