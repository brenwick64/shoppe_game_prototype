# DayAndNightManager.gd (autoload)
extends Node

signal hour_passed(hours: int)

@export var day_length: float = 120.0   # real seconds for a full in-game day
@export var print_only_on_change: bool = true

const SECONDS_PER_DAY: int = 24 * 60 * 60
const SUNRISE_HOUR: int = 6
const SUNSET_HOUR:int = 18

var time_of_day: float = 0.0
var hours: int = 0
var minutes: int = 0
var seconds: int = 0

var _accumulated_seconds: float = 0.0
var _prev_printed_second: int = -1
var _prev_hours: int = -1

func _ready() -> void:
	_accumulated_seconds = 0.0
	_prev_printed_second = -1
	_prev_hours = -1

func _process(delta: float) -> void:
	# how many in-game seconds pass per real second
	var in_game_seconds_per_real_second: float = float(SECONDS_PER_DAY) / max(day_length, 0.0001)

	# advance accumulator and wrap to keep numbers bounded
	_accumulated_seconds += delta * in_game_seconds_per_real_second
	_accumulated_seconds = fmod(_accumulated_seconds, float(SECONDS_PER_DAY))

	var total_seconds: int = int(_accumulated_seconds)
	hours = int(total_seconds / 3600)
	minutes = int((total_seconds % 3600) / 60)
	seconds = total_seconds % 60

	time_of_day = float(total_seconds) / float(SECONDS_PER_DAY)

	#print("%02d:%02d:%02d" % [hours, minutes, seconds])

	# emit hour_passed only once when hour changes
	if hours != _prev_hours:
		hour_passed.emit(hours)
		_prev_hours = hours
