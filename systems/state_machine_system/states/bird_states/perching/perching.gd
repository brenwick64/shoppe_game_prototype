extends State

@export var parent: Node2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var action_delay_range: Vector2 = Vector2(0.5, 2.5)
@export var area_2d: Area2D

@onready var action_timer: Timer = $ActionTimer

var _action_lock: bool = true

## -- helper functions --
func _perform_action() -> void:
	_action_lock = true
	transition.emit("emoting")

func _fly_away() -> void:
	_action_lock = true
	transition.emit("takeoff")

## -- overrides
func _on_enter() -> void:
	area_2d.area_entered.connect(_on_area_2d_area_entered)
	animated_sprite_2d.play("idle_" + parent.direction_name)

func _on_exit() -> void:
	area_2d.area_entered.disconnect(_on_area_2d_area_entered)
	animated_sprite_2d.stop()

func _on_physics_process(_delta: float) -> void:
	if not _action_lock:
		if parent.total_actions < parent.max_actions:
			_perform_action()
		else:
			_fly_away()
	else:
		if action_timer.time_left > 0.0: return # timer already started
		animated_sprite_2d.play("idle_" + parent.direction_name)
		var rand_delay: float = randf_range(action_delay_range.x, action_delay_range.y)
		action_timer.start(rand_delay)

## -- signals --
func _on_action_timer_timeout() -> void:
	_action_lock = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Hitbox: # player or npc
		transition.emit("takeoff")
