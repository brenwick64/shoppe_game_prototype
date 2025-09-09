extends AnimatedSprite2D

@export_category("Light Flicker")
@export var flicker_interval_sec: float = 0.1
@export var flicker_interval_range: Vector2 = Vector2(0.05, 0.05)
@export var flicker_energy_variance: float = 0.25

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var flicker_timer: Timer = $FlickerTimer

const ENERGY_LERP_SPEED: float = 5.0  # How fast the light approaches the target

var _base_energy: float
var _target_energy: float

func _ready() -> void:
	_base_energy = point_light_2d.energy
	_target_energy = _base_energy
	flicker_timer.timeout.connect(_on_flicker_timer_timeout)

func _process(delta: float) -> void:
	point_light_2d.energy = lerp(point_light_2d.energy, _target_energy, delta * ENERGY_LERP_SPEED)

func _on_flicker_timer_timeout() -> void:
	var new_wait_time: float = randf_range(
		flicker_interval_sec - flicker_interval_range.x,
		flicker_interval_sec + flicker_interval_range.y
	)
	var new_energy: float = randf_range(
		_base_energy - flicker_energy_variance,
		_base_energy + flicker_energy_variance
	)
	_target_energy = new_energy
	flicker_timer.start(new_wait_time)
