class_name ResourceIcon
extends Panel

@export var resource_texture: AtlasTexture

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect

func _ready() -> void:
	texture_rect.texture = resource_texture
