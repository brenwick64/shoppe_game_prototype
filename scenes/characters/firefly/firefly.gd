class_name Firefly
extends PointLight2D

# Movement properties
var speed: float = 30.0        # Base movement speed in pixels/sec
var amplitude: float = 30.0    # How far it can wander from the origin
var frequency: float = 1.0     # Speed of wandering direction change

# Flicker properties
var base_energy: float = 0.5   # Base energy after fade-in
var flicker_strength: float = 0.3

# Internal state
var origin: Vector2
var time_offset: float

func _ready() -> void:
	energy = 0.0  # Start fully off
	origin = global_position
	time_offset = randf() * 1000  # Randomize noise start for multiple fireflies

	# Fade in energy
	var fade_in_tween = create_tween()
	fade_in_tween.tween_property(self, "energy", base_energy, 1.0)  # 1 second fade-in

func _process(delta: float) -> void:
	# Smooth random movement using sin/cos for natural wandering
	var t = Time.get_ticks_msec() / 1000.0 + time_offset
	var offset = Vector2(
		sin(t * frequency * 0.7) * amplitude,
		cos(t * frequency * 1.3) * amplitude
	)
	global_position = origin + offset

	# Flicker on top of base energy
	energy = base_energy + flicker_strength * sin(t * 3.0 + time_offset)

func _on_death_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(self, "energy", 0.0, 1.0)  # Fade out over 1 second
	tween.tween_callback(Callable(self, "queue_free"))
