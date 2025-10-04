extends State

func _on_enter() -> void:
	pass

func _on_exit() -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	transition.emit("idle")
