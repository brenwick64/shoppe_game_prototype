class_name Bird
extends Node2D

@export var bird_area_tags: Array[String]
@export var actions_range: Vector2i = Vector2i(1,3)
@export var max_speed: float = 100.0
@export var takeoff_acceleration: float = 300.0
@export var walk_speed: float = 10.0
@export var despawn_boundary_x: int = 2500
@export var despawn_boundary_y: int = 2500

var max_actions: int
var direction_name: String = "right"
var total_actions: int = 0
var target_bird_area: Area2D
var bird_area_visited: bool = false

func _ready() -> void:
	max_actions = randi_range(actions_range.x, actions_range.y)

# despawn boundary checking
func _physics_process(_delta: float) -> void:
	if global_position.x > abs(despawn_boundary_x) or global_position.y > abs(despawn_boundary_y):
		queue_free()
