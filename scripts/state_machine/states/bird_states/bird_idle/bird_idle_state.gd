extends State

@export var parent: Node2D
@export var animated_sprite_2d: AnimatedSprite2D

## -- overrides
func _on_enter() -> void:
	animated_sprite_2d.play("idle_" + parent.direction_name)

func _on_exit() -> void:
	animated_sprite_2d.stop()
