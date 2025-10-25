class_name CraftingComponent
extends Node2D

signal crafting_finished(recipe: RRecipe)

@export var start_audio: RAudioStreamData
@export var finish_audio: RAudioStreamData
@export var ui_z_index_modifier: int = 0

@onready var crafting_progress_bar: CraftingProgressBar = $CraftingProgressBar
@onready var craft_start_sound: OneShotSoundComponent = $CraftStartSound
@onready var craft_finish_sound: OneShotSoundComponent = $CraftFinishSound

func _ready() -> void:
	crafting_progress_bar.z_index = crafting_progress_bar.z_index + ui_z_index_modifier
	craft_start_sound.load_audio_data(start_audio)
	craft_finish_sound.load_audio_data(finish_audio)

## -- public methods --
func craft(recipe: RRecipe) -> void:
	craft_start_sound.play_sound()
	crafting_progress_bar.start(recipe.base_craft_time_seconds, recipe)

## -- signals --
func _on_crafting_progress_bar_finished(recipe: RRecipe) -> void:
	craft_finish_sound.play_sound()
	crafting_finished.emit(recipe)
