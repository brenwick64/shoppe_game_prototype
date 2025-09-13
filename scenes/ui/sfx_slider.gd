extends HSlider

func _ready() -> void:
	var bus_db: float = GlobalAudioManager.get_bus_db("sfx")
	var base_value: float = db_to_linear(bus_db)
	value = base_value
