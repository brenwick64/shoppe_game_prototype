extends Timer


func _on_timeout() -> void:
	get_parent().play_loop()
