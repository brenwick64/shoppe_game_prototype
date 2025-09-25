extends Label

func _ready() -> void:
	_render_text()

## -- public methods --
func get_count() -> int:
	var count:int = int(text)
	return count

func add_count(new_count: int) -> void:
	text = str(new_count)
	_render_text()

func hide_count() -> void:
	visible = false

func show_count() -> void:
	_render_text()

func reset_count() -> void:
	text = str(0)
	_render_text()

## --- helper functions
func _render_text() -> void:
	var current_count: int = int(text)
	visible = current_count != 0
