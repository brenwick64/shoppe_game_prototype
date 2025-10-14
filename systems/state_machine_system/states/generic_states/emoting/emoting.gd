extends State

@export var parent: Node2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var area_2d: Area2D
@export var bird_audio: OneShotSoundComponent
@export var emotes: Array[REmote]
@export var next_state_name: String

## -- helper functions --
func _random_emote() -> void:
	if not emotes: 
		push_warning("warning: no emotes configured while in Emoting state.")
		return
	
	var emote: REmote = emotes.pick_random()
	animated_sprite_2d.play(emote.animation_name + "_" + parent.direction_name)
	if emote.audio_data:
		bird_audio.initial_delay_sec = emote.audio_delay
		bird_audio.load_audio_data(emote.audio_data)
		bird_audio.play_sound()

## -- overrides
func _on_enter() -> void:
	area_2d.area_entered.connect(_on_area_2d_area_entered)
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
	_random_emote()

func _on_exit() -> void:
	area_2d.area_entered.disconnect(_on_area_2d_area_entered)
	animated_sprite_2d.animation_finished.disconnect(_on_animation_finished)
	animated_sprite_2d.stop()

## -- signals --
func _on_animation_finished() -> void:
	for emote: REmote in emotes:
		if animated_sprite_2d.animation.contains(emote.animation_name):
			parent.total_actions += 1
			transition.emit(next_state_name)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Hitbox: # player or npc
		transition.emit("takeoff")
