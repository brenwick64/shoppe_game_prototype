class_name UIConsole
extends Control

@export var scroll_duration_sec: float = 1.0
@export var max_messages: int = 50
@export var console_message_scene: PackedScene

@onready var scroll_container: ScrollContainer = $MainPanel/MarginContainer/Panel/MarginContainer/ScrollContainer
@onready var v_box_container: VBoxContainer = $MainPanel/MarginContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer


## -- public methods --
func add_message(text: String) -> void:
	var console_message: Label = console_message_scene.instantiate()
	console_message.text = text
	v_box_container.add_child(console_message)
	
	# update ui layout and trim excess messages
	await get_tree().process_frame
	await _trim_messages()
	
	_scroll_to_bottom()


## -- helper functions --
func _trim_messages() -> void:
	var bar: VScrollBar = scroll_container.get_v_scroll_bar()
	var before_value: float = bar.value
	var before_max: float = bar.max_value
	# remove first messages exceeding maxiumum amount
	var excess: int = v_box_container.get_child_count() - (max_messages + 1)
	if excess > 0:
		for i: int in range(excess):
			var node: Node = v_box_container.get_child(0)
			v_box_container.remove_child(node)
			node.queue_free()
			
		# apply removals in layout
		await get_tree().process_frame
		
		# preserve visual layout
		var after_max: float = bar.max_value
		var new_value: float = before_value - (before_max - after_max)
		if new_value < 0.0:
			new_value = 0.0
		scroll_container.scroll_vertical = new_value

func _scroll_to_bottom() -> void:
	var bar: VScrollBar = scroll_container.get_v_scroll_bar()
	var target: float = bar.max_value
	var t: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(scroll_container, "scroll_vertical", target, scroll_duration_sec)
