extends State

@export var parent: Node2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var area_2d: Area2D
@export var roam_walk_time_sec: float = 1.0

@onready var roam_walk_timer: Timer = $RoamWalkTimer

var _is_walking: bool = false

## -- helper functions --
func _walk(delta: float) -> void:
	var direction_vector: Vector2 =  Vector2.LEFT if parent.direction_name == "left" else Vector2.RIGHT
	animated_sprite_2d.play("walk_" + parent.direction_name)
	parent.position += direction_vector.normalized() * parent.walk_speed * delta

func _set_parent_walk_direction() -> void:
	var parent_x_pos: float = parent.global_position.x
	var bird_area_x_pos: float = parent.target_bird_area.global_position.x
	if parent_x_pos > bird_area_x_pos: # parent to the right
		parent.direction_name = "left"
	else:                              # parent to the left
		parent.direction_name = "right"

## -- overrides
func _on_enter() -> void:
	area_2d.area_entered.connect(_on_area_2d_area_entered)

func _on_exit() -> void:
	_is_walking = false
	roam_walk_timer.stop() # prevents asynchronous state switching via timeout
	animated_sprite_2d.stop()
	area_2d.area_entered.disconnect(_on_area_2d_area_entered)

func _on_physics_process(delta: float) -> void:
	if _is_walking: 
		_walk(delta)
	else:
		_is_walking = true
		_set_parent_walk_direction()
		roam_walk_timer.start(roam_walk_time_sec)

## -- signal --
func _on_roam_walk_timer_timeout() -> void:
	transition.emit("roaming")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Hitbox: # player or npc
		transition.emit("takeoff")
