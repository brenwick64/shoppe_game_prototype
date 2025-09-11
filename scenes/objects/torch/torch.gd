extends Node

@export_category("Light Flicker")
@export var flicker_interval_sec: float = 0.1
@export var flicker_interval_range: Vector2 = Vector2(0.05, 0.05)
@export var flicker_energy_variance: float = 0.25

@onready var lit_animated_sprite: AnimatedSprite2D = $LitAnimatedSprite
@onready var unlit_animated_sprite: AnimatedSprite2D = $UnlitAnimatedSprite
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var flicker_timer: Timer = $FlickerTimer

const ENERGY_LERP_SPEED: float = 5.0  # How fast the light approaches the target
const SCALE_LERP_SPEED: float = 10.0

var _base_energy: float
var _target_energy: float
var _torch_enabled: bool = true
var _current_sprite: AnimatedSprite2D

func _ready() -> void:
	_base_energy = point_light_2d.energy
	_target_energy = _base_energy
	_check_time(DayAndNightManager.hours)
	flicker_timer.timeout.connect(_on_flicker_timer_timeout)
	DayAndNightManager.hour_passed.connect(_on_hour_passed)

func _process(delta: float) -> void:
	if _torch_enabled: # bloom outwards
		point_light_2d.scale = point_light_2d.scale.lerp(Vector2.ONE, delta * SCALE_LERP_SPEED)
	else: # shut off instantly
		point_light_2d.scale = Vector2.ZERO
	point_light_2d.energy = lerp(point_light_2d.energy, _target_energy, delta * ENERGY_LERP_SPEED)

## - helper functions --
func _check_time(hour: int) -> void:
	if hour >= DayAndNightManager.SUNRISE_HOUR and hour < DayAndNightManager.SUNSET_HOUR:
		_torch_off()
	else:
		_torch_on()

func _torch_on() -> void:
	lit_animated_sprite.visible = true
	unlit_animated_sprite.visible = false
	_torch_enabled = true

func _torch_off() -> void:
	lit_animated_sprite.visible = false
	unlit_animated_sprite.visible = true
	_torch_enabled = false

## -- signals --
func _on_flicker_timer_timeout() -> void:
	if not _torch_enabled: return
	
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

func _on_hour_passed(hour: int) -> void:
	_check_time(hour)
