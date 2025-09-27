class_name PlaceablePreview
extends Node2D

@export var placement_pivot: Marker2D

@onready var block_placement_area: Area2D = $BlockPlacement
@onready var sprite: Sprite2D = $Sprite

const REGULAR_MODULATE: Color = Color(1, 1, 1, 0.5)
const BLOCKED_MODULATE: Color = Color(1, 0, 0, 0.75)

var blocking_areas: Array[Area2D] = []

func _ready() -> void:
	sprite.modulate = REGULAR_MODULATE
	block_placement_area.area_entered.connect(_on_block_placement_area_entered)
	block_placement_area.area_exited.connect(_on_block_placement_area_exited)
	

## -- public methods --
func is_placement_blocked() -> bool:
	return blocking_areas.size() > 0


## -- helper functions --
func _update_sprite_modulate() -> void:
	if is_placement_blocked():
		sprite.modulate = BLOCKED_MODULATE
	else:
		sprite.modulate = REGULAR_MODULATE


## -- signals --
func _on_block_placement_area_entered(area: Area2D) -> void:
	blocking_areas.append(area)
	_update_sprite_modulate()
	
func _on_block_placement_area_exited(area: Area2D) -> void:
	var area_index: int = blocking_areas.find(area)
	if area_index == -1: return
	blocking_areas.remove_at(area_index)
	_update_sprite_modulate()
