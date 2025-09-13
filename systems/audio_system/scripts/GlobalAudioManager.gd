extends Node
# TODO: Create custom audio resources with tags and whatnot
const grass_walk_1: AudioStream = preload("res://audio/player_movement/01-step-grass-trimmed.wav")
const grass_walk_2: AudioStream = preload("res://audio/player_movement/02-step-grass-02_trimmed.wav")

const wood_walk_1: AudioStream = preload("res://audio/player_movement/10_Step_wood_01.wav")
const wood_walk_3: AudioStream = preload("res://audio/player_movement/12_Step_wood_03.wav")

const dirt_walk_1: AudioStream = preload("res://audio/player_movement/04-step-sand-01_trimmed.wav")
const dirt_walk_2: AudioStream = preload("res://audio/player_movement/05-step-sand-02_trimmed.wav")

const stone_walk_1: AudioStream = preload("res://audio/player_movement/07-step-rock-01_trimmed.wav")
const stone_walk_2: AudioStream = preload("res://audio/player_movement/08-step-rock-02_trimmed.wav")

const music_bias: float = 20.0


func _ready() -> void:
	print("GlobalAudioManager ready")

func get_audio_track(key: String) -> Array[AudioStream]:
	match key:
		"move_grass" : return [grass_walk_1, grass_walk_2]
		"move_wood"  : return [wood_walk_1, wood_walk_3]
		"move_dirt"  : return [dirt_walk_1, dirt_walk_2]
		"move_stone"  : return [stone_walk_1, stone_walk_2]
	push_warning("GlobalAudioManager warning: no sound found for: " + key)
	
	return [grass_walk_1, grass_walk_2]
	
func get_bus_db(bus_name: String) -> float:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		return AudioServer.get_bus_volume_db(bus_index)
	return 0.0

func set_bus_db(bus_name: String, value: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(
		bus_index,
		(value - music_bias) if bus_name == "music" else value
	)
func set_bus_mute(bus_name: String, is_muted: bool) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	if bus_index == -1: return
	AudioServer.set_bus_mute(bus_index, is_muted)
