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

func get_audio_track(key: String) -> Array[AudioStream]:
	match key:
		"move_grass" : return [grass_walk_1, grass_walk_2]
		"move_wood"  : return [wood_walk_1, wood_walk_3]
		"move_dirt"  : return [dirt_walk_1, dirt_walk_2]
		"move_stone"  : return [stone_walk_1, stone_walk_2]
	push_warning("GlobalAudioManager warning: no sound found for: " + key)
	
	return [grass_walk_1, grass_walk_2]
