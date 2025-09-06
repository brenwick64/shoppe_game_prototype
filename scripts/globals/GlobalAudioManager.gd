extends Node
# TODO: Create custom audio resources with tags and whatnot
const grass_walk1: AudioStream = preload("res://audio/player_movement/01-step-grass-trimmed.wav")
const grass_walk2: AudioStream = preload("res://audio/player_movement/02-step-grass-02_trimmed.wav")

const wood_walk_1: AudioStream = preload("res://audio/player_movement/10_Step_wood_01.wav")
const wood_walk_3: AudioStream = preload("res://audio/player_movement/12_Step_wood_03.wav")

static func get_audio_track(key: String) -> Array[AudioStream]:
	print(key)
	match key:
		"move_grass" : return [grass_walk1, grass_walk2]
		"move_wood"  : return [wood_walk_1, wood_walk_3]
	return []
