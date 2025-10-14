class_name Placeable
extends Node2D

@export var placed_sound: OneShotSoundComponent
@export var sprite: Sprite2D

@onready var outline_shader: Shader = preload("res://shaders/2d_outline.gdshader")

var item_id: int
var dimensions: Vector2i
var is_loaded_in: bool = false


## -- overrides --
func _ready() -> void:
	# avoids playing the placed sound each time objects are loaded
	if not is_loaded_in:
		placed_sound.play_sound()
	
	# assign shader material
	var shader_material: ShaderMaterial = ShaderMaterial.new()
	shader_material.shader = outline_shader
	sprite.material = shader_material


## -- public methods --
func show_outline() -> void:
	var shader_material: ShaderMaterial = sprite.material
	shader_material.set_shader_parameter("width", 0.55)  
	shader_material.set_shader_parameter("pattern", 1)

func hide_outline() -> void:
	var shader_material: ShaderMaterial = sprite.material
	shader_material.set_shader_parameter("width", 0)
	shader_material.set_shader_parameter("pattern", 1)
