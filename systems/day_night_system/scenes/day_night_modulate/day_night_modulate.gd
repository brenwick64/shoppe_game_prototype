extends CanvasModulate

@export_category("Debug")
@export var DEBUG_LOCK_HOUR: int

@export_category("Configuration")
@export var day_color: Color = Color(1, 1, 1, 1)        
@export var night_color: Color = Color(0.3, 0.4, 0.6, 1)

func _process(_delta: float) -> void:
	if DEBUG_LOCK_HOUR: 
		_update_color(DEBUG_LOCK_HOUR, 0)
		return
	
	# smoothly interpolate color every frame
	_update_color(DayAndNightManager.hours, DayAndNightManager.minutes)

func _update_color(hours: int, minutes: int) -> void:
	# Convert time to normalized 0..1 where 0 = midnight, 0.5 = noon
	var time_normalized: float = (hours + minutes / 60.0) / 24.0

	# Brightness peaks at 12:00 (noon), darkest at 24:00 (midnight)
	var brightness: float = cos((time_normalized - 0.5) * PI * 2.0) * 0.5 + 0.5
	self.color = night_color.lerp(day_color, brightness)
