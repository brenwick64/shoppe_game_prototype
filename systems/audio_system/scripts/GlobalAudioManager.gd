extends Node

var audio_settings_rg: ResourceGroup = preload("res://resources/resource_groups/rg_audio_stream_settings.tres")
var audio_stream_settings: Array[RAudioStreamSettings]

func _ready() -> void:
	audio_settings_rg.load_all_into(audio_stream_settings)
	load_bus_layout()


## -- helper functions --
func _get_audio_by_tag(tag: String) -> Array[RAudioStreamSettings]:
	var settings: Array[RAudioStreamSettings] = []
	for setting: RAudioStreamSettings in audio_stream_settings:
		if tag in setting.tags:
			settings.append(setting)
	return settings


func get_movement_audio_tracks(tag: String) -> Array[RAudioStreamSettings]:
	match tag:
		"move_grass" : return _get_audio_by_tag("move_grass")
		"move_wood"  : return _get_audio_by_tag("move_wood")
	push_warning("GlobalAudioManager warning: no sound found for: " + tag)
	return _get_audio_by_tag("default_movement")

func save_bus_layout(path: String = "res://audio/default_bus_layout.tres") -> void:
	var layout: AudioBusLayout = AudioServer.generate_bus_layout()
	ResourceSaver.save(layout, path)

func load_bus_layout(path: String = "res://audio/default_bus_layout.tres") -> void:
	var layout: AudioBusLayout = load(path)
	if layout:
		AudioServer.set_bus_layout(layout)

func get_bus_db(bus_name: String) -> float:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		return AudioServer.get_bus_volume_db(bus_index)
	return 0.0

func set_bus_db(bus_name: String, value: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(
		bus_index,
		value
	)

func get_bus_mute(bus_name: String) -> bool:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	if bus_index == -1: return false
	return AudioServer.is_bus_mute(bus_index)

func set_bus_mute(bus_name: String, is_muted: bool) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	if bus_index == -1: return
	AudioServer.set_bus_mute(bus_index, is_muted)
