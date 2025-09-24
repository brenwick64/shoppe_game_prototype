class_name ItemPickup
extends Node2D

@export var pickup_texture: AtlasTexture
@export var item_id: int
@export var count: int = 1

@onready var pickup_area: Area2D = $PickupArea
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var arc_move_on_spawn: Node2D = $ArcMoveOnSpawn

var start_pos: Vector2
var end_pos: Vector2

func _ready() -> void:
	sprite_2d.texture = pickup_texture
	arc_move_on_spawn.start_pos = start_pos
	arc_move_on_spawn.end_pos = end_pos

func _on_arc_move_on_spawn_arc_motion_finished() -> void:
	var collision_shape: CollisionShape2D = pickup_area.get_node("CollisionShape2D")
	if collision_shape:
		collision_shape.disabled = false

func _on_pickup_area_area_entered(area: Area2D) -> void:
	var area_parent: Node2D = area.get_parent()
	if area_parent is Player:
		area_parent.pickup(item_id, count)
	queue_free()
