class_name BounceOnSpawn
extends Node

@export var enabled: bool = true
@export var target: Node2D               # If null, uses parent Node2D
@export var dip_scale: float = 0.92      # brief collapse below 1.0
@export var peak_scale: float = 1.08     # overshoot above 1.0
@export var dip_time: float = 0.08       # time to collapse
@export var peak_time: float = 0.10      # time to expand to peak
@export var settle_time: float = 0.12    # time to return to original
@export var squash_amount: float = 0.06  # 0..~0.12 looks nice; 0 = uniform

var _original_scale: Vector2
var _tween: Tween


## -- lifecycle --
func _ready() -> void:
	if not enabled:
		return
	var tgt: Node2D = target if target else _get_parent_node2d()
	if not tgt:
		push_warning("BounceOnSpawn: No valid Node2D target found. Set `target` or make this a child of a Node2D.")
		return
	_original_scale = tgt.scale
	_play(tgt)


## -- public methods --
func play() -> void:
	var tgt: Node2D = target if target else _get_parent_node2d()
	if tgt:
		_play(tgt)


## -- helpers --
func _play(tgt: Node2D) -> void:
	if _tween:
		_tween.kill()

	# Start at full size immediately
	tgt.scale = _original_scale

	# Targets for the three beats: dip -> peak -> settle
	var dip_vec: Vector2 = _mix_scale(dip_scale,  squash_amount)   # squashed vertically, wider horizontally
	var peak_vec: Vector2 = _mix_scale(peak_scale, -squash_amount) # stretched vertically, thinner horizontally

	_tween = create_tween()
	_tween.set_parallel(false)

	# 1) Quick collapse (ease-in feels snappy going down)
	_tween.set_trans(Tween.TRANS_QUAD)
	_tween.set_ease(Tween.EASE_IN)
	_tween.tween_property(tgt, "scale", dip_vec, dip_time)

	# 2) Punch up past 1.0 with a Back ease-out for that elastic "pop"
	_tween.set_trans(Tween.TRANS_BACK)
	_tween.set_ease(Tween.EASE_OUT)
	_tween.tween_property(tgt, "scale", peak_vec, peak_time)

	# 3) Gently settle back to original with a sine ease
	_tween.set_trans(Tween.TRANS_SINE)
	_tween.set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(tgt, "scale", _original_scale, settle_time)


func _mix_scale(s: float, squash: float) -> Vector2:
	# Positive squash widens X and shrinks Y; negative does the inverse.
	# Clamped so we never invert a scale axis.
	var x: float = max(0.01, s + squash)
	var y: float = max(0.01, s - squash)
	return Vector2(_original_scale.x * x, _original_scale.y * y)


func _get_parent_node2d() -> Node2D:
	var p: Node = get_parent()
	return p if p is Node2D else null
