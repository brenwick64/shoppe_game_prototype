extends HSlider

@export var audio_bus_name: String

func _ready() -> void:
	var bus_db: float = GlobalAudioManager.get_bus_db(audio_bus_name)
	print(audio_bus_name)
	print(bus_db)
	var base_value: float = db_to_linear(bus_db)
	value = base_value
