class_name BirdSelector
extends Node

@export var bird_data_rg: ResourceGroup

var bird_arr: Array[RBirdData]

func _ready() -> void:
	bird_data_rg.load_all_into(bird_arr)

## -- methods --
func get_bird(hour: int) -> RBirdData:
	var bird: RBirdData = _select_bird_by_time_of_day(hour)
	if not bird: return null
	var should_spawn: bool = Utils.roll_percentage(bird.spawn_chance)
	if not should_spawn: return null
	return bird

## -- helper functions --
func _select_bird_by_time_of_day(hour) -> RBirdData:
	for bird: RBirdData in bird_arr:
		if bird.spawn_hour == hour:
			return bird
	return null
