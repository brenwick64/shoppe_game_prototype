extends Label

func _ready() -> void:
	_render_text()

## -- public methods --
func add_count(new_count: int) -> void:
	text = str(new_count)
	_render_text()

func reset_count() -> void:
	text = str(0)
	_render_text()

## --- helper functions
func _render_text() -> void:
	var current_count: int = int(text)
	visible = current_count != 0
