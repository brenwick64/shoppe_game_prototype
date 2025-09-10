class_name CameraSpawner
extends Node2D

#@export var camera: Camera2D
@export var spawn_area_padding: Vector2 = Vector2(0,0)
@export var max_spawns: int = 10
@export var spawn_time_sec: float = 1.0
@export var spawnable_scene: PackedScene
@export_category("Debug")
@export var DEBUG_SHOW_SPAWN_AREA: bool = false

@onready var camera: Camera2D = get_parent()
@onready var spawns: Node2D = $Spawns
@onready var spawn_timer: Timer = $SpawnTimer

var _viewport_size: Vector2
var _screen_center: Vector2
var _camera_center_pos: Vector2

func _ready() -> void:
	spawn_timer.wait_time = spawn_time_sec
	_viewport_size = camera.get_viewport_rect().size / camera.zoom
	_screen_center = _viewport_size / 2.0
	_camera_center_pos = camera.global_position - _screen_center 

func _process(_delta: float) -> void:
	_camera_center_pos = camera.global_position - global_position
	queue_redraw()

func _draw() -> void:
	if camera == null: return
	if not DEBUG_SHOW_SPAWN_AREA: return
	var top_left: Vector2 = _camera_center_pos - (_viewport_size / 2.0)
	draw_rect(Rect2(top_left, _viewport_size), Color.RED, false, 3.0)
	if spawn_area_padding != Vector2.ZERO:
		var adjusted_top_left: Vector2 = top_left - spawn_area_padding / 2
		draw_rect(Rect2(adjusted_top_left, _viewport_size + spawn_area_padding), Color.BLUE, false, 3.0)

func _should_spawn() -> bool:
	var spawns_arr: Array[Node] = spawns.get_children()
	return spawns_arr.size() < max_spawns

func _get_random_point_in_camera() -> Vector2:
	var half_width: float = (_viewport_size.x / 2) + (spawn_area_padding.x / 2)
	var half_height: float = (_viewport_size.y / 2) + (spawn_area_padding.y / 2)
	
	var rand_x: float = randf_range(
		_camera_center_pos.x - half_width,
		_camera_center_pos.x + half_width
	)
	var rand_y: float = randf_range(
		_camera_center_pos.y - half_height,
		_camera_center_pos.y + half_height
	)
	
	return Vector2(rand_x, rand_y)

func _on_spawn_timer_timeout() -> void:
	if _should_spawn():
		var spawn_ins: PointLight2D = spawnable_scene.instantiate()
		spawn_ins.global_position = _get_random_point_in_camera()
		spawns.add_child(spawn_ins)
