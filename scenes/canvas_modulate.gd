extends CanvasModulate

# --- Parameters ---
@export_category("Debug")
@export var DEBUG_LOCK_NIGHT: bool = true
@export_category("Configuration")
@export var day_color: Color = Color(1, 1, 1, 1)         # daylight color
@export var night_color: Color = Color(0.3, 0.4, 0.6, 1) # night color
@export var cycle_length: float = 60.0                   # seconds for a full day/night cycle

# Internal
var time: float = 0.0

func _ready() -> void:
	if DEBUG_LOCK_NIGHT:
		self.color = night_color 

func _process(delta: float) -> void:
	if DEBUG_LOCK_NIGHT: return
	time += delta
	var t: float = fmod(time / cycle_length, 1.0)  # normalized 0..1 over the cycle
	var brightness: float = 0.5 + 0.5 * sin(t * TAU) # Smooth sine-based brightness (0 = midnight, 0.5 = noon)
	self.color = night_color.lerp(day_color, brightness)
