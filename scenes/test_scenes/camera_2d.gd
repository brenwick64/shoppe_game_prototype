extends Camera2D


func _ready() -> void:
	snap_mode = Camera2D.SNAP_MODE_PIXEL
	# optional: enable smoothing if you want smooth camera movement
	smoothing_enabled = true
	smoothing_speed = 5.0
