extends Node

@export var flicker_interval_sec: float = 0.1
@export var flicker_interval_range: Vector2 = Vector2(0.05, 0.05)
@export var flicker_energy_variance: float = 0.25
@export var on_off_delay_range_sec: Vector2 = Vector2.ZERO

# child nodes
@onready var lit_animated_sprite: AnimatedSprite2D = $LitAnimatedSprite
@onready var unlit_animated_sprite: AnimatedSprite2D = $UnlitAnimatedSprite
@onready var point_light_2d: PointLight2D = $PointLight2D
# timers
@onready var flicker_timer: Timer = $FlickerTimer
@onready var on_off_timer: Timer = $OnOffTimer

const ENERGY_LERP_SPEED: float = 5.0  # How fast the light approaches the target
const SCALE_LERP_SPEED: float = 10.0

var _base_energy: float
var _target_energy: float
var _torch_enabled: bool = true

func _ready() -> void:
	_base_energy = point_light_2d.energy
	_target_energy = _base_energy
	_toggle_torch()
	flicker_timer.timeout.connect(_on_flicker_timer_timeout)
	on_off_timer.timeout.connect(_on_on_off_timer_timeout)
	DayAndNightManager.hour_passed.connect(_on_hour_passed)

func _process(delta: float) -> void:
	if _torch_enabled: # bloom outwards
		point_light_2d.scale = point_light_2d.scale.lerp(Vector2.ONE, delta * SCALE_LERP_SPEED)
	else: # shut off instantly
		point_light_2d.scale = Vector2.ZERO
	point_light_2d.energy = lerp(point_light_2d.energy, _target_energy, delta * ENERGY_LERP_SPEED)

## - helper functions --
func _should_torch_be_lit(hour: int) -> bool:
	if hour >= DayAndNightManager.SUNRISE_HOUR and hour < DayAndNightManager.SUNSET_HOUR:
		return false
	else: return true

func _torch_on() -> void:
	_torch_enabled = true
	lit_animated_sprite.visible = true
	unlit_animated_sprite.visible = false

func _torch_off() -> void:
	_torch_enabled = false
	lit_animated_sprite.visible = false
	unlit_animated_sprite.visible = true

func _toggle_torch() -> void:
	var hour: int = DayAndNightManager.hours
	if _should_torch_be_lit(hour) and not _torch_enabled:
		_torch_on()
	elif not _should_torch_be_lit(hour) and _torch_enabled:
		_torch_off()

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

func _on_on_off_timer_timeout() -> void:
	_toggle_torch()

func _on_hour_passed(_hour: int) -> void:
	var rand_interval: float = randf_range(on_off_delay_range_sec.x, on_off_delay_range_sec.y)
	on_off_timer.start(rand_interval)
