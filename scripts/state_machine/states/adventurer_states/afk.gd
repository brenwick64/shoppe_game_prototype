extends State

@export var parent: Node2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var name_label: Label

@onready var afk_timer: Timer = $AFKTimer


## -- overrides --
func afk() -> void:
	name_label.text = "<" + parent.adventurer_name + "> - AFK"

func back() -> void:
	name_label.text = "<" + parent.adventurer_name + ">"

func _ready() -> void:
	afk_timer.timeout.connect(_on_afk_timer_timeout)

func _on_enter() -> void:
	animated_sprite_2d.play("idle_" + parent.direction_name)
	var random_time: float = randi_range(10, 30)
	afk_timer.start(random_time)
	afk()

func _on_exit() -> void:
	animated_sprite_2d.stop()
	back()

func _on_physics_process(delta: float) -> void:
	pass

## -- signals --
func _on_afk_timer_timeout() -> void:
	transition.emit("idle")
