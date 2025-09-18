extends State

@export var parent: Node2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var despawn_time_sec: float = 20.0

@onready var despawn_timer: Timer = $DespawnTimer

func _fly(delta: float) -> void: 
	var direction_vector: Vector2 = Vector2.LEFT if parent.direction_name == "left" else Vector2.RIGHT 
	parent.position += direction_vector.normalized() * parent.max_speed * delta

## -- overrides
func _on_physics_process(delta: float) -> void:
	_fly(delta)

func _on_enter() -> void:
	animated_sprite_2d.play("fly_" + parent.direction_name)
	despawn_timer.start(despawn_time_sec)

func _on_exit() -> void:
	animated_sprite_2d.stop()

func _on_despawn_timer_timeout() -> void:
	parent.queue_free()
