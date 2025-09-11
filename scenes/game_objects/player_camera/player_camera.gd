extends Camera2D

@export var target: Node2D
@export var smoothing_time: float = 1.5  # Smaller = snappier, Larger = slower
@export var min_zoom: float = 0.1        # Optional clamp for zoom

var _zoom_scale: float
var _smoothed_pos: Vector2
var _smoothed_zoom: float

func _ready() -> void:
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	if not target: return
	_smoothed_pos = target.global_position
	_zoom_scale = zoom.x
	_smoothed_zoom = _zoom_scale

func _physics_process(delta: float) -> void:
	if not target: return
		
	# Smoothly move the camera toward the target using exponential damping
	#  - 0.001 is the tiny “residual” fraction left after smoothing (controls how close to target we get each second)
	#  - delta / smoothing_time scales it per frame, making it frame-rate independent
	#  - The result is a weight for lerp: small when close, large when far, giving natural spring movement
	var desired_position: Vector2 = target.global_position
	_smoothed_pos = _smoothed_pos.lerp(
		desired_position,
		1.0 - pow(0.001, delta / smoothing_time)
	)

	_smoothed_zoom = lerp(_smoothed_zoom, _zoom_scale, 1.0 - pow(0.001, delta / smoothing_time))
	_smoothed_zoom = max(_smoothed_zoom, min_zoom)
	zoom = Vector2(_smoothed_zoom, _smoothed_zoom)

	var screen_pos: Vector2 = _smoothed_pos * _smoothed_zoom
	# Round to nearest screen pixel
	screen_pos = Vector2(round(screen_pos.x), round(screen_pos.y))
	# Convert back to world coordinates
	global_position = screen_pos / _smoothed_zoom
