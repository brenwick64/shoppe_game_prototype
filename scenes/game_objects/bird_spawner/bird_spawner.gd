extends Node2D

@export var enabled: bool = true
@export var birds: Array[RBirdData]
@export var spawn_interval_sec: float = 1
@export var max_spawned: int = 10	
@export var spawn_distance_x: float = 500.0
@export var max_spawn_distance_y: float = 200.0

var bird_count: int = 0

func _ready() -> void:
	DayAndNightManager.hour_passed.connect(_on_hour_passed)

func select_bird_by_time_of_day(hour: int) -> RBirdData:
	for bird: RBirdData in birds:
		if bird.spawn_hour == hour:
			return bird
	return null

func spawn_bird(bird: RBirdData) -> void:
	if not enabled: return
	if not birds: return
	if bird_count >= max_spawned: return
	
	var bird_ins: Node2D = bird.bird_scene.instantiate()
	var global_pos: Vector2 = _get_random_spawn_pos()
	bird_ins.global_position = global_pos
	bird_ins.direction_name = _get_bird_direction(global_pos)
	bird_ins.tree_exited.connect(_on_bird_tree_exited)
	bird_count += 1
	add_child(bird_ins)

## -- helper functions --
func _get_random_spawn_pos() -> Vector2:
	var random_x = spawn_distance_x * Utils.random_sign()
	var random_y: float = randf_range(-max_spawn_distance_y, max_spawn_distance_y)
	return global_position + Vector2(random_x, random_y)

func _get_bird_direction(global_pos: Vector2) -> String:
	return "left" if global_pos.x > 0 else "right"

## -- signals --
func _on_hour_passed(hour: int) -> void:
	var bird: RBirdData = select_bird_by_time_of_day(hour)
	if not bird: return
	var should_spawn: bool = Utils.roll_percentage(bird.spawn_chance)
	if not should_spawn: return
	spawn_bird(bird)

func _on_bird_tree_exited() -> void:
	bird_count -= 1
