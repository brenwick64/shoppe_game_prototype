class_name FloatingText
extends Label

@export var Y_OFFSET: float = -65.0
@export var FLOAT_DISTANCE: float = 20.0
@export var FLOAT_DURATION: float = 0.75

var parent_node: Node2D
var floating_text: String

# Extra offset from the float-up animation
var float_offset_y: float = 0.0

## -- overrides --
func _ready() -> void:
	self.text = floating_text
	_float_upwards()

func _process(_delta: float) -> void:
	if !is_instance_valid(parent_node): 
		return
	
	var canvas_transform: Transform2D = get_viewport().get_canvas_transform()
	var screen_pos: Vector2 = canvas_transform * parent_node.global_position

	var x_offset: float = size.x / 2.0
	position = screen_pos + Vector2(-x_offset, Y_OFFSET + float_offset_y)


## -- helper functions --
func _float_upwards() -> void:
	var t: Tween = create_tween()
	t.set_trans(Tween.TRANS_SINE)
	t.set_ease(Tween.EASE_OUT)

	# Animate float_offset_y upward
	t.tween_property(self, "float_offset_y", float_offset_y - FLOAT_DISTANCE, FLOAT_DURATION)

	# Optional: fade out as it floats
	t.parallel().tween_property(self, "modulate:a", 0.0, FLOAT_DURATION)

	# Remove node after animation
	t.tween_callback(self.queue_free)
