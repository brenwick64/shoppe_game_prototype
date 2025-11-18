class_name FloatingTextUI
extends CanvasLayer

@onready var floating_text_scene: PackedScene = preload("res://scenes/ui/floating_text/floating_text/floating_text.tscn")

var current_messages: Array[ChatMessage]

## -- public methods --
func add_text(node: Node2D, message: String, y_offset: float) -> void:
	var test = floating_text_scene.instantiate()
	test.y_offset = y_offset
	test.floating_text = "-2"
	test.parent_node = node
	add_child(test)
