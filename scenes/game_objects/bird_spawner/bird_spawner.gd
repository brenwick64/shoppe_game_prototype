extends Node2D

@export var enabled: bool = true
@export var spawn_interval_sec: float = 1
@export var max_spawned: int = 10
# TODO: tie this to camera view distance
@export var spawn_distance_x: float = 500.0
@export var max_spawn_distance_y: float = 200.0

@export var bird_selector: BirdSelector
@export var bird_area_selector: BirdAreaSelector 

var bird_count: int = 0

func _ready() -> void:
	DayAndNightManager.hour_passed.connect(_on_hour_passed)

func spawn_bird(bird: RBirdData, bird_area: BirdArea) -> void:
	var bird_ins: Node2D = bird.bird_scene.instantiate()
	var spawn_pos: Vector2 = _get_bird_spawn_pos(bird_area)
	# set instance variables
	bird_ins.global_position = spawn_pos
	bird_ins.direction_name = _get_bird_spawn_direction_name(spawn_pos, bird_area)
	bird_ins.tree_exited.connect(_on_bird_tree_exited)
	
	add_child(bird_ins)

### -- helper functions --
func _can_spawn_bird() -> bool:
	if not enabled: return false
	if bird_count >= max_spawned: return false
	return true

func _get_bird_spawn_pos(area: BirdArea) -> Vector2:
	var y_base_value: float = area.global_position.y
	var rand_x: float = spawn_distance_x * Utils.random_sign()
	var rand_y: float = y_base_value + randf_range(-max_spawn_distance_y, max_spawn_distance_y)
	return Vector2(rand_x, rand_y)

func _get_bird_spawn_direction_name(spawn_pos: Vector2, area: BirdArea) -> String:
	if spawn_pos.x > area.global_position.x: return "left"
	else: return "right"

## -- signals --
func _on_hour_passed(hour: int) -> void:
	var bird: RBirdData = bird_selector.get_bird(hour)
	if not bird: return
	var area: BirdArea = bird_area_selector.get_bird_area(bird)
	if not area: return
	if not _can_spawn_bird(): return
	spawn_bird(bird, area)
	bird_count += 1

func _on_bird_tree_exited() -> void:
	bird_count -= 1
