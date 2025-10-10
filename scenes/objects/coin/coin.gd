extends Node2D

@onready var arc_move_on_spawn: Node2D = $ArcMoveOnSpawn
@onready var despawn_timer: Timer = $DespawnTimer

var start_pos: Vector2
var end_pos: Vector2

func _ready() -> void:
	arc_move_on_spawn.start_pos = start_pos
	arc_move_on_spawn.end_pos = end_pos
	despawn_timer.timeout.connect(_on_despawn_timer_timeout)
	despawn_timer.start()

func _on_despawn_timer_timeout() -> void:
	queue_free()
