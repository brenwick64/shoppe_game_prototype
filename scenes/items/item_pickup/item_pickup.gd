class_name ItemPickup
extends Node2D

@export var pickup_texture: AtlasTexture

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.texture = pickup_texture
